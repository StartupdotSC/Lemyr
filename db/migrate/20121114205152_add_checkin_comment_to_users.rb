class AddCheckinCommentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :checkin_comment, :string

  end
end
