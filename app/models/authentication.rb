class Authentication < ActiveRecord::Base
    belongs_to :user

    def update_omniauth(omniauth)
        self.update_attributes(:provider => omniauth['provider'], 
                          :uid => omniauth['uid'], 
                          :token => omniauth['credentials']['token'], 
                          :secret => omniauth['credentials']['secret'], 
                          :name => omniauth['info']['nickname'])
    end
end
