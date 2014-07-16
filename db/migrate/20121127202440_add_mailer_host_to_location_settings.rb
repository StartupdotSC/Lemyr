class AddMailerHostToLocationSettings < ActiveRecord::Migration
  def change
    add_column :location_settings, :mailer_host, :string

  end
end
