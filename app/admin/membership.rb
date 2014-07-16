ActiveAdmin.register Membership do
    menu :label => "Membership Plans", :parent => "Location"
    actions :index, :edit, :update, :new, :create, :destroy
    config.filters = false
    config.batch_actions = false

    index do
        column :name
        column "Billing ID (Stripe Plan ID)", :stripe_id
        column "Displayed Price", :price
        column "Monthly Passes Included", :monthly_passes
        column "Self Service?", :self_service
        column "Check-ins deduct Day Passes?", :deducts_daypass
        column "Discounts on Day Pass purchases?", :discounts_daypass
        actions
    end

    form do |f|
        f.inputs do
            f.input :name
            f.input :stripe_id, :label => "Billing ID (e.g. Stripe Plan ID. Leave blank for non-subscriptions.)"
            f.input :price, :label => "Price (Display only. Set actual price in Stripe Dashboard.)"
            f.input :self_service, :label => "User Selectable/Self Service?"
            f.input :monthly_passes, :label => "Monthly Passes Included (Credited when subscription invoice is paid)"
            f.input :deducts_daypass, :label => "Check-ins deduct from Day Pass balance?"
            f.input :discounts_daypass, :label => "Discounts on Day Pass purchases?"
            f.input :daypass_discount, :label => "Day Pass discount % (Leave blank to use discount in Location Settings)"
        end
        f.actions
    end
end
