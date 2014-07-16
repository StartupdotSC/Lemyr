class AddCheckinStatusIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :checkin_status_id, :integer
  end
end
