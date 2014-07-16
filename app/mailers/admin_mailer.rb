class AdminMailer < ActionMailer::Base
  include ActionView::Helpers::NumberHelper

  def opts 
    LocationSettings.get
  end

  def new_user_email(user)
    @content = "<strong>Name:</strong> #{user.name} <br/><strong>Email:</strong><a href='mailto:#{user.email}'>#{user.email}</a><br/><br/><em>Admin:<a href='http://#{$current_host}/admin/users/#{user.id}/edit'>Edit Profile</a></em>"
    mail(:to => self.opts.notification_email, :from => self.opts.notification_email,
      :subject => "#{self.opts.name}: New Member Joined - #{user.name}", :template_name => 'admin_email')
  end

  def user_membership_changed_email(user)
    @content = "New membership selected: #{user.membership.name.to_s}"
    mail(:to => self.opts.notification_email, :from => self.opts.sender_email,
      :subject => "#{self.opts.name}: #{user.name} Changed Membership", :template_name => 'admin_email')
  end

  def user_daypass_transfer_complete(transfer, user)
     @content = "#{user.name} has received #{transfer.quantity} Day #{"Pass".pluralize(transfer.quantity)} from #{transfer.user.name}!"
     mail(:to => "#{transfer.user.email},#{transfer.to_email},#{self.opts.notification_email}", :from => self.opts.sender_email,
       :subject => "#{self.opts.name}: Day #{"Pass".pluralize(transfer.quantity)} Tranferred", :template_name => 'admin_email')
  end

  def user_daypass_transfer(transfer)
     @content = "#{transfer.user.name} has sent you #{transfer.quantity} Day #{"Pass".pluralize(transfer.quantity)}!<br/><br/>\
      Click this link to claim them:<br/>\
      <a href='http://#{$current_host}/transfer/#{transfer.redeem_code}'>http://#{$current_host}/transfer/#{transfer.redeem_code}</a>
      <br/><br/>\
      You will be asked to create an account or sign in with your existing account to redeem."
     mail(:to => "#{transfer.user.email},#{transfer.to_email},#{self.opts.notification_email}", :from => self.opts.sender_email,
       :subject => "#{self.opts.name}: #{transfer.user.name} sent #{transfer.quantity} Day #{"Pass".pluralize(transfer.quantity)}", :template_name => 'admin_email')
  end

  def user_daypass_purchased(user, amount)
     @content = "Day Pass Purchase: #{user.name}. Quantity: #{amount}"
     mail(:to => self.opts.notification_email, :from => self.opts.sender_email,
       :subject => "#{self.opts.name}: #{user.name} bought #{amount} Day Passes", :template_name => 'admin_email')
  end

  def user_daypass_credit(user, amount)
    @content = "Your day pass balance has increased by #{amount} and your total day pass balance is now #{user.total_passes}.<br/>We look forward to seeing you!"
    mail(:to => "#{user.email}", :from => self.opts.sender_email,
        :subject => "#{self.opts.name}: Day Passes added for #{user.name} ", :template_name => 'admin_email')
  end

  def user_creditcard_cancel(user)
    @content = "If this user is cancelling their membership, please collect their badge and update their profile in the Admin Dashboard."
    mail(:to => self.opts.notification_email, :from => self.opts.sender_email,
      :subject => "#{self.opts.name}: #{user.name} Removed Credit Card", :template_name => 'admin_email')
  end

  def user_charge_succeeded(user, event)
    @content = "Your card (#{event['data']['object']['card']['type']} - #{event['data']['object']['card']['last4']}) has been successfully charged <strong>#{number_to_currency(event['data']['object']['amount']/100.0)}</strong>.<br/><em>#{event['data']['object']['description']}</em><br/><a href='http://#{$current_host}/billing'>You can view your payment transaction history here</a><br/> We truly appreciate your business!"
   mail(:to => "#{user.email},#{self.opts.notification_email}", :from => self.opts.sender_email,
      :subject => "#{self.opts.name}: Credit Card Charged", :template_name => 'admin_email')
  end

  def user_charge_failed(user, event)
    @content = "Your card (#{event['data']['object']['card']['type']} - #{event['data']['object']['card']['last4']}) failed to charge <strong>#{number_to_currency(event['data']['object']['amount']/100.0)}</strong><br/><em>#{event['data']['object']['description']}</em>. <br/> Your membership will be suspended until your charge is successfully processed. If you would like to use a different card, please edit your profile on the members' site."
    mail(:to => "#{user.email},#{self.opts.notification_email}", :from => self.opts.sender_email,
      :subject => "#{self.opts.name}: Credit Card Failed", :template_name => 'admin_email')
  end

  def user_charge_refunded(user, event)
    @content = "Your card (#{event['data']['object']['card']['type']} - #{event['data']['object']['card']['last4']}) was credited <strong>#{number_to_currency(event['data']['object']['amount_refunded']/100.0)}</strong><br/><em>#{event['data']['object']['description']}</em>.<br/>"
    mail(:to => "#{user.email},#{self.opts.notification_email}", :from => self.opts.sender_email,
      :subject => "#{self.opts.name}: Credit Card Refund", :template_name => 'admin_email')
  end

  def user_invoice_receipt(user, data)
    @user = user
    @data = data
    mail(:to => "#{user.email},#{self.opts.notification_email}", :from => self.opts.sender_email,
      :subject => "#{self.opts.name}: Invoice", :template_name => 'invoice_email')
  end

  def admin_info(info, subject = "[Admin Info Email]")
    @content = info
    mail(:to => self.opts.notification_email, :from => self.opts.sender_email,
      :subject => "#{self.opts.name}: #{subject}", :template_name => 'admin_email')
  end

  def admin_charge_receipt(email, amount, description, charge)
    @content = "The #{charge.card.type} ending with #{charge.card.last4} was charged $#{amount} for \"#{description}\"<br/><br/>Thank you for your business!"
    mail(:to => "#{email},#{self.opts.notification_email}", :from => self.opts.sender_email,
      :subject => "#{self.opts.name}: Receipt for Payment", :template_name => 'admin_email')
  end

  def admin_member_message(users, subject, message)
    @content = message
    mail(:to => self.opts.sender_email, :bcc => users.join(","), :from => self.opts.sender_email, :subject => "#{self.opts.name}: #{subject}", :template_name => 'admin_email')
  end
  
end
