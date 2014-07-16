class CreateLocationSettings < ActiveRecord::Migration
  def change
    create_table :location_settings do |t|
      t.string :name
      t.boolean :freeday
      t.float :daypass_price
      t.float :daypass_discount
      t.string :sender_email
      t.string :notification_email

      t.timestamps
    end
  end
end
