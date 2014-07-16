class AddCorporateNameToLocationSettings < ActiveRecord::Migration
  def change
    add_column :location_settings, :corporate_name, :string
  end
end
