class UserStatus < ActiveRecord::Base
  belongs_to :user
  belongs_to :checkin_status

  attr_accessible :checkin, :checkin_status_id, :comment, :user_id, :user
 
  def self.get_currently_checked_in()
    checkins = []

    User.where("last_status_id IS NOT NULL").each do |u|
      status = UserStatus.find(u.last_status_id)
      checkins << status if status.checkin
    end

    checkins
  end

  def display_name
    checkin_status.label
  end

end
