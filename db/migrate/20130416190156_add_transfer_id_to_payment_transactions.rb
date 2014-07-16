class AddTransferIdToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :transfer_id, :integer
  end
end
