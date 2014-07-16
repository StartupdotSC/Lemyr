class AddStuffToLocationSettings < ActiveRecord::Migration
  def change
    add_column :location_settings, :main_site_url, :string
    add_column :location_settings, :location_description, :string
  end
end
