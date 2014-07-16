class AddTransactionKeyToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :transaction_key, :string
  end
end
