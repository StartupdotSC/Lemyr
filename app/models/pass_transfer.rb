class PassTransfer < ActiveRecord::Base
  belongs_to :user
  attr_accessible :quantity, :redeem_code, :to_email
end
