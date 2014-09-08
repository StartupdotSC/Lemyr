class AddUserAgreementToLocationSettings < ActiveRecord::Migration
  def change
    add_column :location_settings, :user_agreement, :text
  end
end
