class AddTransactionDateToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :transaction_date, :datetime
  end
end
