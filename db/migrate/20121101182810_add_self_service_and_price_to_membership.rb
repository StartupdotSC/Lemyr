class AddSelfServiceAndPriceToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :self_service, :boolean

    add_column :memberships, :price, :float

  end
end
