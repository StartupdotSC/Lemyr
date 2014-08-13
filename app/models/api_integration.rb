class ApiIntegration < ActiveRecord::Base
    attr_accessible :provider, :app, :key, :secret, :oauth_token, :oauth_secret, :location_settings_id

    belongs_to :location_settings
    validates_uniqueness_of :provider, :message => "An integration already exists for this provider."

    after_create :reload
    after_update :reload
    after_destroy :reload

    def reload
        LocationSettings.refresh
    end

    def display_name
        ""
    end
end
