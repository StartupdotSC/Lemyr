class PaymentTransaction < ActiveRecord::Base
    
    belongs_to :user

    has_many :transferred, :class_name => "PaymentTransaction", :foreign_key => "transfer_id"
    belongs_to :transfer, :class_name => "PaymentTransaction"

    #attr_accessible :amount, :description, :transaction_type, :transaction_date, :transaction_key, :transfer_id, :user_id
end
