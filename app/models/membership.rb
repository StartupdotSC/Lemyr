class Membership < ActiveRecord::Base
    attr_accessible :stripe_id, :price, :self_service, :name, :deducts_daypass, :discounts_daypass, :daypass_discount, :monthly_passes
    has_many :users

    def to_s
        name
    end

    def get_label
        "#{self.name} " + ((!self.price.nil? and self.price > 0.0)? "- #{helpers.number_to_currency(self.price)}":"")
    end

    def helpers
        ActionController::Base.helpers
    end
end
