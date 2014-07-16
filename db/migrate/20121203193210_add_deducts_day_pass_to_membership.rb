class AddDeductsDayPassToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :deducts_daypass, :boolean, :default => true

  end
end
