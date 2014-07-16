class ChangeTypeInPaymentTransactions < ActiveRecord::Migration
  def change
    rename_column :payment_transactions, :type, :transaction_type
  end
end
