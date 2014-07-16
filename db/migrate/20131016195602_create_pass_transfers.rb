class CreatePassTransfers < ActiveRecord::Migration
  def change
    create_table :pass_transfers do |t|
      t.string :to_email
      t.string :redeem_code
      t.integer :quantity
      t.references :user

      t.timestamps
    end
    add_index :pass_transfers, :user_id
  end
end
