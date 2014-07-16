require 'stripe'
require 'json'

class StripeEventsController < ApplicationController

    def incoming
        raw = request.body.read
        event = JSON.parse(raw)

        attrs = {
                    :transaction_type => event['type'], 
                    :transaction_date => Time.at(event['created']).to_datetime,
                    :description => event['data']['object']['description'],
                    :data => raw
                };
        
        attrs[:transaction_key] = event['data']['object']['id'] if !event['data']['object']['id'].nil?
        attrs[:amount] = event['data']['object']['amount']/100.0 if !event['data']['object']['amount'].nil?
        attrs[:description] = "Plan: #{event['data']['object']['plan']['name']}" if !event['data']['object']['plan'].nil?


        # if this is a user oriented event, set up relation and send emails
        user = User.where("stripe_id = ?", event['data']['object']['customer']).first
        attrs[:user] = user

        if !event['data']['object']['id'].nil?
            transaction = PaymentTransaction.find_or_create_by_transaction_key(event['data']['object']['id']) 
        else
            transaction = PaymentTransaction.create
        end   
        transaction.update_attributes(attrs)

        if !transaction.user.nil?
            if event['type'].eql?("charge.succeeded") 
                AdminMailer.user_charge_succeeded(user, event).deliver
            end

            if event['type'].eql?("charge.failed") 
                AdminMailer.user_charge_failed(user, event).deliver
            end

            if event['type'].eql?("charge.refunded") 
                AdminMailer.user_charge_refunded(user, event).deliver
            end

            if event['type'].eql?("invoice.payment_succeeded") or event['type'].eql?("invoice.payment_failed")
                user.invoice_succeeded! if event['type'].eql?("invoice.payment_succeeded") 
                AdminMailer.user_invoice_receipt(user, event['data']['object']).deliver
            end
        end

        # if the user changed their plan, go ahead and consider it a successful change
        # this is because Stripe creates a invoice item for the proration and 
        # won't fire a invoice.payment_succeeded 
        if event['type'].eql?("customer.subscription.updated")
            user.invoice_succeeded!
        end

        # after saving, resolve transfer relations
        if event['type'].starts_with?("transfer.") and !event['data']['object']['transactions']['data'].nil?
            event['data']['object']['transactions']['data'].each do |ch|
                charge = PaymentTransaction.where("transaction_key = ?", ch['id']).first
                charge.transferred << transaction if !charge.nil?
            end
        end

        begin
            info = %{
                User: #{!user.nil? ? user.name : event['data']['object']['customer']}.<br/> 
                Type: #{event['type']}<br/>
                #{event.to_yaml}
                }

            AdminMailer.admin_info(info).deliver
        rescue Exception => e
            AdminMailer.admin_info(e.message).deliver
        end
        
        render :json => { "webhooks" => "success" }
    end

end
