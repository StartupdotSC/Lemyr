class AddMembershipToUser < ActiveRecord::Migration
  def change
    add_column :users, :membership_id, :integer

  end
end
