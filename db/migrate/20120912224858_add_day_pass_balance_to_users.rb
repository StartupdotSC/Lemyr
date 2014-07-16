class AddDayPassBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daypass_balance, :integer, :default => 0
  end
end
