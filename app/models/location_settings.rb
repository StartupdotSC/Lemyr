class LocationSettings < ActiveRecord::Base
  has_many :api_integrations, :dependent => :delete_all
  belongs_to :membership

  after_create :reload
  after_update :reload
  after_destroy :reload

  def to_s
     self.name
  end

  def reload
    LocationSettings.refresh
  end

  def integration(provider)
    if ApiIntegration.table_exists?
      provider = provider.to_s if provider.is_a? Symbol
      self.api_integrations.select{ |api| api.provider.eql? provider }[0]
    end
  end

  def configure_stripe
    Stripe.api_key = LocationSettings.get.integration(:stripe).key
    Stripe.api_key = LocationSettings.get.integration(:stripe).oauth_secret if !Rails.env.production?
  end

  def configure_analytics
    GA.tracker = LocationSettings.get.integration(:analytics).app
  end

  def configure_active_admin config
    config.site_title = LocationSettings.get.name
    config.site_title_image = LocationSettings.get.logo_url if defined?(LocationSettings.get.logo_url) and !LocationSettings.get.logo_url.nil?
  end

  def configure_devise config
    config.mailer_sender = LocationSettings.get.sender_email

    api = LocationSettings.get.integration(:facebook)
    if !api.nil?
      config.omniauth :facebook, api.key, api.secret,
        {:scope => 'email, offline_access, read_stream, publish_stream, publish_actions'}
    end

    api = LocationSettings.get.integration(:twitter)
    if !api.nil?
      config.omniauth :twitter, api.key, api.secret
    end

    api = LocationSettings.get.integration(:linkedin)
    if !api.nil?
      config.omniauth :linkedin, api.key, api.secret
    end

    api = LocationSettings.get.integration(:google_oauth2)
    if !api.nil?
      config.omniauth :google_oauth2, api.app, api.secret
    end

    api = LocationSettings.get.integration(:foursquare)
    if !api.nil?
      config.omniauth :foursquare, api.key, api.secret
      Foursquare.configure do |config|
      config.consumer_key = api.key
      config.consumer_secret = api.secret
      config.api_version = "20140101"
      end
    end
  end

  def configure_paperclip config
    api = LocationSettings.get.integration(:amazon_s3)

    if !api.nil?
      Paperclip::Attachment.default_options[:storage] = :s3
      Paperclip::Attachment.default_options[:s3_protocol] = 'https'
      Paperclip::Attachment.default_options[:s3_credentials] = {
        :bucket => api.app, #ENV['AWS_BUCKET'],
        :access_key_id => api.key, #ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => api.secret, #ENV['AWS_SECRET_ACCESS_KEY']
      }
    end
  end

  def self.refresh
    @@instance = nil
    @@instance = LocationSettings.first if ApiIntegration.table_exists?

    if !@@instance.nil?
      Devise.setup do |config|
        @@instance.configure_devise config
      end

      # ActiveAdmin.setup do |config|
      #   @@instance.configure_active_admin config
      # end

      Lemyr::Application.configure do
        @@instance.configure_paperclip(config) if !@@instance.integration(:amazon_s3).nil?
        #config.action_mailer.default_url_options = { host: @@instance.mailer_host } if defined?(@@instance.mailer_host)

        api = @@instance.integration(:mandrill)
        if !api.nil?
          ActionMailer::Base.smtp_settings = {
            enable_starttls_auto: true,
            address: api.oauth_secret,
            port: api.oauth_token,
            authentication: :plain,
            user_name: api.app,
            password: api.key
          }

          ActionMailer::Base.smtp_settings[:domain] = api.secret if !api.secret.nil? and !api.secret.empty?
        end
      end

      @@instance.configure_analytics if !@@instance.integration(:analytics).nil?
      @@instance.configure_stripe if !@@instance.integration(:stripe).nil?

      logger.info "Lemyr: Refreshed Location Settings."
    end
  end

  def self.get
    @@instance ||= LocationSettings.first if ApiIntegration.table_exists?
  end
end
