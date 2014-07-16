class AddProfileToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :profile, :string
  end
end
