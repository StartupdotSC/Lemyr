class CreateCheckinStatuses < ActiveRecord::Migration
  def change
    create_table :checkin_statuses do |t|
      t.string :label

      t.timestamps
    end
  end
end
