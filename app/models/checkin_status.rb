class CheckinStatus < ActiveRecord::Base
  attr_accessible :label

  has_many :user_statuses

  def to_s
    label
  end
end
