class AddAttachmentAvatarAttachedToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :avatar_attached
    end
  end

  def self.down
    drop_attached_file :users, :avatar_attached
  end
end
