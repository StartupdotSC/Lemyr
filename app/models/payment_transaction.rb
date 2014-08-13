class PaymentTransaction < ActiveRecord::Base
  attr_accessible :amount, :description, :transaction_type, :transaction_date, :transaction_key, :transfer_id, :user_id

  belongs_to :user
  belongs_to :transfer, :class_name => "PaymentTransaction"
  has_many :transferred, :class_name => "PaymentTransaction", :foreign_key => "transfer_id"
end
