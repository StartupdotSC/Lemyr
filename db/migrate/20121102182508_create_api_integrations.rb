class CreateApiIntegrations < ActiveRecord::Migration
  def change
    create_table :api_integrations do |t|
      t.string :provider
      t.string :app
      t.string :key
      t.string :secret
      t.string :oauth_token
      t.string :oauth_secret

      t.timestamps
    end
  end
end
