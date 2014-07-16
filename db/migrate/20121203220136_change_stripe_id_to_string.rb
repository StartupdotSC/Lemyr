class ChangeStripeIdToString < ActiveRecord::Migration
  def change
    change_column :memberships, :stripe_id, :string
    add_column :memberships, :discounts_daypass, :boolean, :default => true

  end
end
