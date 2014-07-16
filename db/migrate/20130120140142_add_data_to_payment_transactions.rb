class AddDataToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :data, :text
  end
end
