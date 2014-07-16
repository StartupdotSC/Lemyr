class AddLocationSettingsIdToApiIntegrations < ActiveRecord::Migration
  def change
    unless column_exists? :api_integrations, :location_settings_id
        add_column :api_integrations, :location_settings_id, :integer 
    end
  end
end
