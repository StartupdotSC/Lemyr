class CreatePaymentTransactions < ActiveRecord::Migration
  def change
    create_table :payment_transactions do |t|
      t.integer :user_id
      t.string :type
      t.float :amount
      t.string :description

      t.timestamps
    end
  end
end
