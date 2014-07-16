class AddCheckinToUser < ActiveRecord::Migration
  def change
    add_column :users, :checkin, :datetime

  end
end
