class AddPricesToLocationSettings < ActiveRecord::Migration
  def change
    add_column :location_settings, :daypass_price3, :decimal

    add_column :location_settings, :daypass_price5, :decimal

  end
end
