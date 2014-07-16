class CheckinStatus < ActiveRecord::Base
    has_many :user_statuses

    def to_s
        label
    end
end
