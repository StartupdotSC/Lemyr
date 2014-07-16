class AddPlansUrlToLocationSettings < ActiveRecord::Migration
  def change
    add_column :location_settings, :membership_plans_url, :string

  end
end
