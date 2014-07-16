require 'twitter'
require 'linkedin'
require 'koala'
require 'foursquare'
require 'stripe'

class User < ActiveRecord::Base
  include ActiveModel::Dirty

  before_create :set_defaults
  after_create :post_create
  before_update :pre_update
  after_destroy :post_destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :stripe_id, :name, :phone,
                  :unconfirmed_email, :authentication_token, :confirmation_token,
                  :membership_id, :checkin_status_id,
                  :checkin, :avatar, :badge, :badge_user_id,
                  :agreement, :daypass_balance, :last_status_id, :company_name, :mailbox_number,
                  :avatar_attached, :monthly_passes

  has_attached_file :avatar_attached, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  define_attribute_methods = [:membership_id]

  has_many :pass_transfers
  has_many :authentications, :dependent => :delete_all
  has_many :user_statuses, :dependent => :delete_all, :order => "created_at DESC"
  has_many :payment_transactions, :order => "created_at DESC"
  #belongs_to :last_status, :class_name => "UserStatus"

  belongs_to :membership

  # user has accepted the user agreement
  def accept_agreement!
    self.agreement = true;
    self.save!
  end

  # use authentication connection to get user avatar
  def set_avatar_for_provider!(provider)
    self.select_avatar!(self.get_avatar_for_provider(provider))
  end

  # set the url for the user avatar
  def select_avatar!(url)
     self.avatar = url
     self.avatar_attached = URI.parse(self.avatar)
     self.save!
  end

  def avatar_url
      self.avatar_attached.url(:thumb)
  end


  # retrieve the profile link for a given authentication
  # persist if a full fetch is required
  def get_profile_for_provider(provider)
    auth = self.get_omniauth provider
    if !auth.nil?
      if auth.profile.nil?
        auth.profile = self.fetch_profile_for_provider provider
        auth.save!
      end
      return auth.profile
    end
  end

  # use appropriate api to build the profile link for a given integration
  def fetch_profile_for_provider(provider)
    begin

      if provider.eql?(:twitter)
        auth = get_omniauth :twitter
        api = LocationSettings.get.integration(:twitter)
        if !auth.nil? and !api.nil?
          Twitter.configure do |config|
            config.consumer_key = api.key
            config.consumer_secret = api.secret
            config.oauth_token = auth.token
            config.oauth_token_secret = auth.secret
          end
          return "http://twitter.com/#{Twitter.user(auth[:name]).screen_name}"
        end
      end

      if provider.eql?(:linkedin)
        auth = get_omniauth :linkedin
        api = LocationSettings.get.integration(:linkedin)
        if !auth.nil? and !api.nil?
          client = LinkedIn::Client.new(api.key, api.secret)
          client.authorize_from_access(auth[:token], auth[:secret])
          return client.profile(:fields => %w(public-profile-url)).public_profile_url;
        end
      end

      if provider.eql?(:facebook)
        begin
          auth = get_omniauth :facebook
          graph = Koala::Facebook::API.new(auth[:token])
          return graph.get_object("me").link
        rescue => e
          logger.error e.message
          e.backtrace.each { |line| logger.error line }
        end

      end

      if provider.eql?(:google_oauth2)
        auth = get_omniauth :google_oauth2
        api = LocationSettings.get.integration(:google_oauth2)
        if !auth.nil? and !api.nil?
          person = GooglePlus::Person.get(auth[:uid], :key => api.key)
          return person.url if !person.nil?
        end
      end

      if provider.eql?(:foursquare)
        auth = get_omniauth :foursquare
        u = Foursquare::User.new(auth[:token])
        res = u.perform_graph_request("users/self")
        return "http://foursquare.com/user/#{res['response']['user']['id']}" if !res.nil?
      end
    rescue => e
      logger.error e.message
      e.backtrace.each { |line| logger.error line }
    end
  end

  # snag the avatar URL for a given integration
  def get_avatar_for_provider(provider)
    if !provider.nil?
      begin
        if provider.eql?(:twitter)
          auth = get_omniauth :twitter
          api = LocationSettings.get.integration(:twitter)
          if !auth.nil? and !api.nil?
            Twitter.configure do |config|
              config.consumer_key = api.key
              config.consumer_secret = api.secret
              config.oauth_token = auth.token
              config.oauth_token_secret = auth.secret
            end
            return Twitter.user(auth[:name]).profile_image_url_https(:bigger)
          end
        end

        if provider.eql?(:linkedin)
          auth = get_omniauth :linkedin
          api = LocationSettings.get.integration(:linkedin)
          if !auth.nil? and !api.nil?
            client = LinkedIn::Client.new(api.key, api.secret)
            client.authorize_from_access(auth[:token], auth[:secret])
            return client.profile(:fields => %w(picture-url)).picture_url.gsub('/http/i', 'https');
          end
        end

        if provider.eql?(:facebook)
          begin
            auth = get_omniauth :facebook
            graph = Koala::Facebook::API.new(auth[:token])
            return graph.get_picture("me", :type => 'normal')
          rescue => e
            logger.error e.message
            e.backtrace.each { |line| logger.error line }
          end
        end

        if provider.eql?(:google_oauth2)
          auth = get_omniauth :google_oauth2
          api = LocationSettings.get.integration(:google_oauth2)
          if !auth.nil? and !api.nil?
            person = GooglePlus::Person.get(auth[:uid], :key => api.key)
            return person.image.url if !person.nil?
          end
        end

        if provider.eql?(:foursquare)
          auth = get_omniauth :foursquare
          u = Foursquare::User.new(auth[:token])
          res = u.perform_graph_request("users/self")
          return res['response']['user']['photo'] if !res.nil?
        end
      rescue => e
        logger.error e.message
        e.backtrace.each { |line| logger.error line }
      end
    end
    return "/assets/avatar.png"
  end

  # retrieve the preferred integration services for the user
  def get_checkin_defaults
    auths = {}
    self.authentications.each { |k| auths[k.provider] = k if k.checkin }
    auths
  end

  # last status change for this user
  def get_last_status
    UserStatus.find(self.last_status_id) if !self.last_status_id.nil?
  end

  def get_last_checkin
    UserStatus.find(:all, :conditions => ["user_id = ? and checkin = ?", self.id, true], :order => "created_at DESC", :limit => "1").first
  end

  def perform_checkout!(comment = "Checked Out")
    status = UserStatus.create({:user => self, :checkin => false, :comment => comment})
    self.last_status_id = status.id
    self.user_statuses << status
    self.save!
  end

  def total_passes
    return self.daypass_balance.to_i + self.monthly_passes.to_i
  end

  def add_daypass!(amount)
    newbalance = self.daypass_balance.to_i
    newbalance += amount;
    self.daypass_balance = newbalance
    self.save!
    AdminMailer.user_daypass_credit(self, amount).deliver if (amount > 0)
  end

  def deduct_daypass!(amount, use_monthly = true)
    remainder = amount

    # if there's monthly passes, take what we can from that first
    if use_monthly and remainder > 0 and (!self.monthly_passes.nil? and self.monthly_passes > 0)
      if self.monthly_passes > remainder
        self.monthly_passes -= remainder
        remainder = 0
      else
        remainder -= self.monthly_passes
        self.monthly_passes = 0
      end
    end

    # if we didn't take anything from monthly passes, take from
    # the daypass balance (allow to go negative)
    if remainder > 0 and self.daypass_balance > 0
      self.daypass_balance -= remainder
    end

    self.save!
  end

  def can_deduct_daypass
    if !LocationSettings.get.freeday and (!self.membership.nil? and self.membership.deducts_daypass)
      prev_checkin = self.get_last_checkin
      if (prev_checkin.nil? or prev_checkin.created_at < Time.zone.now - 24.hours)
        return true;
      end
    end
    return false
  end

  def perform_checkin!(params)

    # Deduct day pass balance:
    # - it's not a free day
    # - it's a first time member or a supporter/day pass member
    # - we've never checked in or already checked in today
    # - it's nights/weekends member and it's night time or the weekend
    if self.can_deduct_daypass
      self.deduct_daypass!(1)
    end

    # build our checkin object
    status = UserStatus.create({:user => self, :checkin => true})

    # handle the actual status
    if params.has_key?'checkin_status_id'
      status.checkin_status = CheckinStatus.find(params['checkin_status_id'].to_i)
    else
      status.checkin_status = CheckinStatus.first;
    end

    # comment
    if !params.has_key?'comment' or params['comment'].empty?
      params['comment'] = "#{self.name} is \"#{status.checkin_status.label}\""
      status.comment = status.checkin_status.label
    else
      status.comment = params['comment']
    end

    status.save!

    self.last_status_id = status.id
    self.user_statuses << status
    self.save!

    # Do the integration check in if we can
    begin
      if params.has_key?("linkedin")
        auth = get_omniauth :linkedin
        api = LocationSettings.get.integration(:linkedin)
        if !auth.nil? and !api.nil?
          client = LinkedIn::Client.new(api.key, api.secret, consumer_options)
          client.authorize_from_access(auth[:token], auth[:secret])
          client.add_share({ :comment => "#{params['comment']} - at #{LocationSettings.get.main_site_url}",
                             :content => {
                                'title' => "#{LocationSettings.get.name}",
                                'description'   => LocationSettings.get.location_description,
                                'submitted-url' => LocationSettings.get.main_site_url,
                                'submitted-image-url' => LocationSettings.get.logo_url
                              }})
        end
      end
    rescue => e
      logger.error e.message
      e.backtrace.each { |line| logger.error line }
    end

    begin
      if params.has_key?("facebook")
       auth = get_omniauth :facebook
        api = LocationSettings.get.integration(:facebook)
        if !auth.nil? and !api.nil?
          graph = Koala::Facebook::API.new(auth[:token])
          app = graph.get_object(api.key)
          graph.put_wall_post(params['comment'], { "place" => api.oauth_token })
        end
      end
    rescue => e
      logger.error e.message
      e.backtrace.each { |line| logger.error line }
    end

    begin
      if params.has_key?("foursquare")
        auth = get_omniauth :foursquare
        api = LocationSettings.get.integration(:foursquare)
        if !auth.nil? and !api.nil?
          checkins = Foursquare::Checkins.new(auth[:token])
          checkins.add( { venueId:api.app, shout:params['comment'], :broadcast => 'public', :ll => api.oauth_token })
        end
      end
    rescue => e
      logger.error e.message
      e.backtrace.each { |line| logger.error line }
    end

    begin
      if params.has_key?("twitter")
        auth = get_omniauth :twitter
        api = LocationSettings.get.integration(:twitter)
        if !auth.nil? and !api.nil?
          Twitter.configure do |config|
            config.consumer_key = api.key
            config.consumer_secret = api.secret
            config.oauth_token = auth.token
            config.oauth_token_secret = auth.secret
          end
          Twitter.update("#{params['comment']} - at #{LocationSettings.get.main_site_url} #cowork")

          # do some stuff on the Twitter account
          Twitter.configure do |config|
            config.consumer_key = api.key
            config.consumer_secret = api.secret
            config.oauth_token = api.oauth_token
            config.oauth_token_secret = api.oauth_secret
          end

          Twitter.follow(auth.name)

          if TweetBack.count > 0
            tweet = TweetBack.all.sample.tweet
            tweet.gsub!("{user}", "@#{auth.name}")
            tweet.gsub!("{comment}", params['comment'])
            tweet.gsub!("{status}", status.checkin_status.label)
            Twitter.update(tweet)
          end
        end
      end
    rescue => e
      logger.error e.message
      e.backtrace.each { |line| logger.error line }
    end


  end

  def first_friday?
     # determine the first Friday of the current month
    firstFriday = Date.new(Time.now.year, Time.now.month, 1)
    firstFriday += firstFriday.wday <= 5 ? 5 - firstFriday.wday : firstFriday.wday
    Date.today == firstFriday
  end

  def can_check_in?
    self.sign_in_count <= 1 or #first time signing in
      LocationSettings.get.freeday or
        (!self.membership.nil? and !self.membership.deducts_daypass ) or
          (self.total_passes > 0) #positive day pass balance
  end

  def is_checked_in?
    last_status = self.get_last_status
    (!last_status.nil? and
      last_status.checkin and
        last_status.created_at >= Time.now.beginning_of_day)
  end

  def freshen_passes
    # successful billing so freshen
    if !self.membership.nil? and !self.membership.monthly_passes.nil? and self.membership.monthly_passes > 0
      self.monthly_passes = self.membership.monthly_passes
    else
      self.monthly_passes = 0
    end
  end

  def invoice_succeeded!
    self.freshen_passes
    self.save!
  end

  def has_payment?
    if !self.stripe_id.nil?
        customer = Stripe::Customer.retrieve(self.stripe_id)
        begin
          return !customer.active_card.nil?
        rescue => e
          logger.error e.message
          e.backtrace.each { |line| logger.error line }
          return false
        end

    end
    return false
  end

  def get_payment_identifier
    unless self.stripe_id.nil?
      customer = Stripe::Customer.retrieve(self.stripe_id)
      if defined?customer.active_card and !customer.active_card.nil?
        "#{customer.active_card.type} ending with #{customer.active_card.last4}"
      else
        "None"
      end
    end
  end

  def remove_stripe!
    begin
      if !self.stripe_id.nil?
        customer = Stripe::Customer.retrieve(self.stripe_id)
        customer.delete
        self.stripe_id = nil
      end
    rescue Stripe::CardError => e
      logger.error e.message
      e.backtrace.each { |line| logger.error line }
    end

    self.set_default_membership
    self.save!

    AdminMailer.user_creditcard_cancel(self).deliver
    return "removed"
  end



  def apply_charge(amount, description) # amount is in cents
    if !self.stripe_id.nil?
      amount = (amount * 100).to_i if !amount.is_a? Integer
      customer = Stripe::Customer.retrieve(self.stripe_id)
      charge = Stripe::Charge.create(
                            :amount => amount,
                            :currency => "usd",
                            :customer => customer.id,
                            :description => "#{self.email} - #{description}"
                          )
      return charge
    end
  end

  def self.create_charge(amount, card, description)
    amount = (amount * 100).to_i if !amount.is_a? Integer
    charge = Stripe::Charge.create(
            :amount => amount,
            :currency => "usd",
            :card => card,
            :description => description
        )
    return charge
  end

  def update_stripe!(ccToken) #optional ccToken will update the users credit card information
    begin

      customer = Stripe::Customer.retrieve(self.stripe_id) if !self.stripe_id.nil?

      if customer.nil?
        customer = Stripe::Customer.create(
                                :email => self.email,
                                :description => "Member #{self.name} (#{self.id})",
                                :card => ccToken)
        self.stripe_id = customer.id;
        self.save!
      else
        customer.card = ccToken
        customer.save
      end

      if !self.membership.nil? and !self.membership.stripe_id.blank?
        customer.update_subscription(:plan => self.membership.stripe_id)
      end

    rescue StandardError => e
      logger.error e.message
      e.backtrace.each { |line| logger.error line }
      return "#{e.message}"
    end
    return ccToken
  end

  def pre_update
    # update email subscription
    mailchimp = LocationSettings.get.integration(:mailchip)
    if Rails.env.production? and !mailchimp.nil?
      h = Hominid::API.new(mailchimp.key)
      #list_id = /^[\d]+(\.[\d]+){0,1}$/ === mailchimp.app? mailchimp.app.to_i : h.find_list_id_by_name(mailchimp.app)
      list_id = mailchimp.app
      h.list_subscribe(list_id, self.email, {'FNAME' => "", 'LNAME' => "" }, 'html', false, true, true, true)
    end

    # if we have payment information, update the cowork membership
    if membership_id_changed?
      if has_payment?
          customer = Stripe::Customer.retrieve(self.stripe_id)
          if !customer.nil?
            if !self.membership.stripe_id.blank?
              customer.update_subscription(:plan => self.membership.stripe_id)
            elsif !customer.subscription.nil?
              customer.cancel_subscription(:at_period_end => true)
            end
          end
      end
      self.freshen_passes
      AdminMailer.user_membership_changed_email(self).deliver
    end

    if email_changed? and has_payment?
       customer = Stripe::Customer.retrieve(self.stripe_id)
          if !customer.nil?
            customer.email = self.email
            customer.save
          end
    end

  end


  def has_password?
    !encrypted_password.blank?
  end

  def password_required?
    #return false if new_record?
    super && (authentications.empty? || !password.blank?)
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

    #Override Devise's update with password to allow registration edits without password entry
  def update_with_password(params={})
    if params['password'].nil? or params['password'].empty?
      params.delete(:current_password)
      self.update_without_password(params)
    else
      self.update_attributes(params)
    end
  end

  def get_omniauth(provider)
    provider = provider.to_s if provider.is_a? Symbol
    return self.authentications.select{ |auth| auth.provider.eql? provider }[0]
  end

  def apply_omniauth(omniauth)
    #raise omniauth['info']['email'].inspect
    self.email = omniauth['info']['email'] if self.email.blank? && omniauth['info'].key?('email')
    self.name = omniauth['info']['name'] if self.name.blank? && omniauth['info'].key?('name')

    auth = authentications.build(:provider => omniauth['provider'],
                          :uid => omniauth['uid'],
                          :token => omniauth['credentials']['token'],
                          :secret => omniauth['credentials']['secret'],
                          :name => omniauth['info']['nickname'])

    auth.profile = self.fetch_profile_for_provider(omniauth['provider'].to_sym)
    auth.save!

    self.select_avatar!(omniauth['provider'].to_sym) if self.avatar_attached.nil?
  end

  protected

  def set_defaults
    self.set_default_membership
    self.avatar = "/assets/avatar.png"
    #self.authentications.each { |k| self.set_avatar_for_provider!(k.provider.to_sym) }
  end

  def set_default_membership
    self.membership = LocationSettings.get.membership
  end

  def post_create
    # api = LocationSettings.get.integration(:mailchimp)
    # if Rails.env.production? and !api.nil?
    #   h = Hominid::API.new(api.key)
    #   h.list_subscribe(api.app, self.email, {'FNAME' => "", 'LNAME' => "" }, 'html', false, true, true, true)
    # end
    AdminMailer.new_user_email(self).deliver
  end

  def post_destroy
    begin
      api = LocationSettings.get.integration(:mailchimp)
      if !api.nil?
        h = Hominid::API.new(api.key)
        h.list_unsubscribe(h.find_list_id_by_name(api.app), self.email, true, true, true)
      end
    rescue => e
      logger.error e.message
      e.backtrace.each { |line| logger.error line }
    end

  end

end
