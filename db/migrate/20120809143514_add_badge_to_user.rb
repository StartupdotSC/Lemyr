class AddBadgeToUser < ActiveRecord::Migration
  def change
    add_column :users, :badge, :string

  end
end
