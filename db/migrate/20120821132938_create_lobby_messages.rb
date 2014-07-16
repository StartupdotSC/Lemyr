class CreateLobbyMessages < ActiveRecord::Migration
  def change
    create_table :lobby_messages do |t|
      t.string :text

      t.timestamps
    end
  end
end
