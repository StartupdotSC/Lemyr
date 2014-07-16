class AddBadgeUserIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :badge_user_id, :string

  end
end
