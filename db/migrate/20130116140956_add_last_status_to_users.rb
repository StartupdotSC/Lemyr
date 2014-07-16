class AddLastStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_status_id, :integer
  end
end
