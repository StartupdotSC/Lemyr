class AddMembershipToLocationSettings < ActiveRecord::Migration
  def change
    add_column :location_settings, :membership_id, :integer
  end
end
