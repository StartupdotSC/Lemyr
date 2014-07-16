class ChangeAuthentications < ActiveRecord::Migration
  def change
  	change_column :authentications, :uid, :text, :limit => nil
  	change_column :authentications, :token, :text, :limit => nil
  	change_column :authentications, :name, :text, :limit => nil
  	change_column :authentications, :secret, :text, :limit => nil
  	change_column :authentications, :profile, :text, :limit => nil
  end
end
