class AddMailboxNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mailbox_number, :string
  end
end
