class AddDaypassDiscountToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :daypass_discount, :float
  end
end
