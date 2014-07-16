class CreateUserStatuses < ActiveRecord::Migration
  def change
    remove_column :users, :checkin_status_id
    remove_column :users, :checkin_comment
    remove_column :users, :checkin

    create_table :user_statuses do |t|
      t.integer :user_id
      t.string :comment
      t.integer :checkin_status_id
      t.boolean :checkin

      t.timestamps
    end

  end
end
