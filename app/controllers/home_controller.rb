require "open-uri"
require "rmeetup"

class HomeController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :agreement, :avatar, :daypass_balance,
    :checkin, :checkout, :membership_options, :credit_card, :credit_card_remove,
    :billing, :status, :transfer, :purchase]

  def index
     if LocationSettings.get.nil?
        render :text => "Gah! You need to do some <a href='/admin'>admin set up</a>!"
        return
     end

     unless current_user.nil?
      redirect_to :action => :agreement if !current_user.agreement
    end
  end

  def agreement
    if !current_user.nil? and params.has_key? 'accepted'
      current_user.accept_agreement!
      redirect_to :action => :index
    end
  end

  def display
    render :layout => "display"
  end

  def avatar
    if params.has_key? :user
      u = User.find(params[:user])
      redirect_to u.avatar_attached.url(:thumb)
    else
      unless current_user.nil?
        current_user.select_avatar!(params[:avatar])
        render :json => { "avatar" => current_user.avatar_attached.url}
      else
        render :nothing => true
      end
    end
  end

  def meetups
    api = LocationSettings.get.integration(:meetup)
    events = Array.new(3)
    if !api.nil?
      RMeetup::Client.api_key = api.key
      events = RMeetup::Client.fetch(:events, { :sign => "true", :venue_id => api.app } )
    end
    render :json => events
  end

  def checkedin_users
    render :json => {"checkins" =>  UserStatus.get_currently_checked_in}, :include => :user
  end

  def lobby_messages
    messages = LobbyMessage.all

    api = LocationSettings.get.integration(:meetup)
    if !api.nil?
       RMeetup::Client.api_key = api.key
       events = RMeetup::Client.fetch(:events,{ :sign => "true", :venue_id => api.app})
       events.each do |e|
         evt = e.event;
         time = Time.zone.at(evt['time']/1000)
         isToday = time < Time.now.end_of_day
         messages << { :text => "<p class='event'><div class='#{ isToday ? "today" : "upcoming"}'>#{ isToday ? "TODAY" : "Upcoming"}: <strong>#{evt['name']}</strong></div>#{time.strftime("on %A, %B %-d <br/> at %l:%M%P")}" }
       end
    end
    render :json => { "messages" => messages }
  end

  def daypass_balance
    if current_user.nil?
        render :json => { "daypass_balance" => 0 }
    else
        render :json => { "daypass_balance" => current_user.total_passes }
    end
  end

  def checkin
    unless current_user.nil?
        current_user.perform_checkin! params
        render :json => { "daypass_balance" => current_user.total_passes, "user_id" => current_user.id }
    else
      render :nothing => true
    end
  end

  def checkout
    unless current_user.nil?
        current_user.perform_checkout! "User Checked Out"
        render :json => { "checkout" => current_user.get_last_status.to_s, "user_id" => current_user.id }
    else
      render :nothing => true
    end
  end

  def membership_options
    unless current_user.nil?
      conditions = "self_service != FALSE"
      conditions += " AND (stripe_id IS NULL OR stripe_id = '')" if !current_user.has_payment?
      membership_options = Hash[Membership.where(conditions).collect do |m|
                                      [m.id, m.get_label]
                                    end]

      # Make sure the user's current membership is in the options list so it
      # remains in tact if the select is hidden OR they can select it again
      # if they are looking to change.
      # *** THIS PURPOSELY IGNORES THE SELF SERVICE RESTRCTION ***
      if !current_user.membership.nil? and !membership_options.has_key?(current_user.membership.id)
        membership_options[current_user.membership.id] = current_user.membership.get_label
      end

      render :json => { "options" => membership_options, "current" => current_user.membership.id }
    else
      render :nothing => true
    end
  end

  def credit_card
    unless current_user.nil?
        result = current_user.update_stripe! params[:token]
        render :json => { "token" => result, "identifier" => current_user.get_payment_identifier }
    else
      render :nothing => true
    end
  end

  def credit_card_remove
    unless current_user.nil?
        result = current_user.remove_stripe!
        render :json => { "result" => result }
    else
      render :nothing => true
    end
  end

  def user_directory
    @users = User.order("last_sign_in_at DESC").all
  end

  def billing
  end

  def status
  end

  def transfer
    if request.post? and params.has_key? :to_email
      begin

        # determine the base price based on Location Settings
        quantity = params[:quantity].to_i


        if quantity > current_user.daypass_balance
          raise "You do not have enough passes for that! You currently have #{current_user.daypass_balance} transferrable #{"pass".pluralize(current_user.daypass_balance)}."
        else
          transfer = PassTransfer.create
          transfer.user = current_user
          transfer.quantity = quantity
          transfer.to_email = params[:to_email]
          transfer.redeem_code = Devise.friendly_token.first(6)
          transfer.save!
          AdminMailer.user_daypass_transfer(transfer).deliver
          current_user.deduct_daypass!(quantity, false)
        end

      rescue Exception => e
         render :json => { "result" => "#{e.message}" }
         return;
      end

      flash[:notice] = "Your transfer was successful!"
      render :json => { "result" => "success" }
    elsif request.get? and params.has_key? :code
      xfer = PassTransfer.where(redeem_code: params[:code]).first
      if !xfer.nil? and !current_user.nil?
        current_user.add_daypass!(xfer.quantity)
        AdminMailer.user_daypass_transfer_complete(xfer, current_user).deliver
        @transfer = xfer.clone
        xfer.destroy
      end
    end
  end

  def purchase
    if request.post? and params.has_key? :amount
      begin

        # determine the base price based on Location Settings
        amount = params[:amount].to_i
        opts = LocationSettings.get
        charge = opts.daypass_price if amount == 1
        charge = opts.daypass_price3 if amount == 3
        charge = opts.daypass_price5 if amount == 5

        # do the discounting
        if current_user.membership.discounts_daypass
          if !current_user.membership.daypass_discount.nil?
            discount = (current_user.membership.daypass_discount/100)
          else
            discount = (opts.daypass_discount/100)
          end

          # inverse the discount to make it a simple multiply
          discount = 1.0 - discount
          charge *= discount
        end

        # convert to pennies for Stripe
        charge *= 100
        charge = charge.to_i

        description = "Day Pass Purchase (#{amount}) for #{current_user.email}"

        if params[:payment_option].eql?("file")
          raise 'You do not have a credit card on file' if !current_user.has_payment?
          current_user.apply_charge(charge, description)
          current_user.add_daypass!(amount)
        else
          card = {
                    :number => params[:card_number],
                    :exp_month => params[:card_month],
                    :exp_year => params[:card_year],
                    :cvc => params[:card_code],
                 }
          charge = User.create_charge(charge, card, "#{current_user.name} - #{description}")

          if !charge.paid
            raise 'There was a problem processing your request.'
          else
            current_user.add_daypass!(amount)
          end
        end

      rescue Exception => e
         render :json => { "result" => "#{e.message} (Details: #{charge},#{amount})" }
         return;
      end
      AdminMailer.user_daypass_purchased(current_user, amount).deliver
      flash[:notice] = "Your purchase was successful!"
      render :json => { "result" => "success" }
    end

  end

end
