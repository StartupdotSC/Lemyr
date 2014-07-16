ActiveAdmin.register PaymentTransaction do
  menu :label => "Payment Transactions", :parent => "Members", :priority => 10

  filter :transaction_type
  filter :amount
  filter :user
  filter :transaction_key
  filter :transaction_date
  filter :created_at


  index do
        selectable_column
        column :user, :sortable => :user_id do |info|
            if !info.user.nil?
                div(:class => "member-avatar", :style => "background-image:url(#{info.user.avatar_attached.url(:thumb)});")
                b link_to(info.user.name, edit_admin_user_path(info.user))
            end
        end
        column :transaction_type
        column :description
        column :amount
        column :transfer
        column :created_at, :label => "Date/Time"
        actions
    end


    csv do
      column :transaction_type
      column :description
      column :amount
      column("Member") do |pt|
        if (!pt.user.nil?)
          "#{pt.user.name}, #{pt.user.email}"
        end
      end
      column("Related Transactions") do |pt|
        if (pt.transaction_type.eql?("transfer.paid"))
          pt.transferred.each do |t|
            "#{t.transaction_date.to_s(:long)} #{(!t.user.nil? ? t.user.name : "")} #{t.transaction_type} #{number_to_currency(t.amount)} #{t.transaction_key}"
          end
        end
      end
    end

end
