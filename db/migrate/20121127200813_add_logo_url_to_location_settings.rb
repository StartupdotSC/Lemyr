class AddLogoUrlToLocationSettings < ActiveRecord::Migration
  def change
    add_column :location_settings, :logo_url, :string

  end
end
