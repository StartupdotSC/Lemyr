class AddCheckinToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :checkin, :boolean, :default => true

  end
end
