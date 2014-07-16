class AddMonthlyPasses < ActiveRecord::Migration
  def change
  	add_column :memberships, :monthly_passes, :integer, :default => 0
  	add_column :users, :monthly_passes, :integer, :default => 0
  end
end
