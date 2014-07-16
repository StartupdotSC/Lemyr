ActiveAdmin.register User do
    menu :label => "Manage Members", :parent => "Members", :priority => 1
    actions :index, :show, :edit, :update, :new, :create, :destroy

    filter :name
    filter :membership
    filter :badge
    #filter :stripe_id, :label => 'Has Payment on File?', :as => :select, :collection => [['No', 'none'],['Yes', 'assigned']]

    config.batch_actions = false

    index :as => :grid do |user|
        status = user.get_last_status
        table do
          tr do
            td :class => "avatar" do
              div(:class => "member-avatar", :style => "background-image:url(#{user.avatar_attached.url(:thumb)});")
            end
            td :class => "info" do
              h3 link_to(user.name, admin_user_path(user))
              status_tag(status.checkin? ? "Checked In" : "Checked Out", status.checkin ? :ok : :warn) if !status.nil?
              ul do
                if !status.nil? and status.checkin
                  li "<a href='/admin/users/checkin?user_id=#{user.id}&checkin=true'>Check Out</a>".html_safe
                end
                li "#{user.membership.name}" if !user.membership.nil?
                li "Daypass Balance: #{user.daypass_balance.nil? ? 0 : user.daypass_balance}"
                li "Monthly Passes: #{user.monthly_passes.nil? ? 0 : user.monthly_passes}"
                li link_to("Edit #{user.name}", edit_admin_user_path(user))
                li link_to(user.email, "mailto:#{user.email}")
              end
            end
          end
        end
        #column :email
        #column :membership
        #column :badge
        #column :badge_user_id
        #column :daypass_balance
        #actions
    end

    show do |user|
      attributes_table do
        row :avatar do
          div(:class => "member-avatar", :style => "background-image:url(#{user.avatar_attached.url(:thumb)});")
        end
        row :id
        row :name
        row :company_name
        row :email do
          link_to "#{user.email}", "mailto:#{user.email}"
        end
        row :phone
        row :mailbox_number
        row :last_status do
          if !user.last_status_id.nil?
            status = UserStatus.find(user.last_status_id)
            if !status.nil?
              status_tag(status.checkin? ? "Checked In" : "Checked Out", status.checkin ? :ok : :warn)
              "#{status.comment}" if status.checkin
            end
          end
        end

        row :sign_in_as_user do
          link_to "Login as #{user.name}", "/switch_user?scope_identifier=user_#{user.id}"
        end
        row :membership
        row :daypass_balance
        row :monthly_passes
        row :stripe_id
        row :last_sign_in_at
        row :current_sign_in_ip
      end

      panel "Payment History" do
        table do
          tr do
            th "Timestamp"
            th "Type"
            th "Amount"
            th "Description"
          end
          user.payment_transactions.each do |t|
            tr do
              td t.transaction_date.nil? ? t.created_at.to_formatted_s(:long_ordinal) : t.transaction_date.to_formatted_s(:long_ordinal)
              td t.transaction_type
              td t.amount
              td t.description
            end
          end
        end
      end

      panel "Status History" do
        table do
          tr do
            th "Timestamp"
            th "Status"
            th "Availability"
          end
          user.user_statuses.each do |status|
            tr do
              td status.created_at.to_formatted_s(:long_ordinal)
              td do
                status_tag(status.checkin? ? "Checked In" : "Checked Out", status.checkin ? :ok : :warn)
                "#{status.comment}" if status.checkin
              end
              td status.checkin_status
            end
          end
        end
      end

      active_admin_comments
    end

    form do |f|
      f.inputs "Details" do
        f.input :membership
        f.input :name
        f.input :company_name
        f.input :phone
        f.input :mailbox_number
        f.input :badge, :label => "Key Fob ID"
        f.input :badge_user_id, :label => "Badge User Code"
        f.input :email
        #f.input :daypass_balance
      end
      f.actions
    end

    sidebar :credit_user, :only => :index
    sidebar :one_time_charge, :only => :index

    #  “/admin/users/user_charge
    # "user_id"=>"8", "amount"=>"20.00"
    collection_action :user_charge, :method => :post do
      u = User.find(params[:user_id])
      amt = (params[:amount].to_f * 100).to_i
      if amt > 0 and !u.nil?
        charge = u.apply_charge(amt, "#{params[:description]} (Charged by Admin #{current_admin_user.email})")
        AdminMailer.admin_charge_receipt(u.email, params[:amount], params[:description], charge).deliver
        flash[:notice] = "#{u.name} was charged $#{amt/100.0}."
        redirect_to :action => :index
      else
        flash[:error] = "Invalid amount or user."
        redirect_to :action => :index
      end
    end

    collection_action :checkin do
      u = User.find(params[:user_id])
      if !u.nil?
        checkin = params[:checkin].to_i > 0
        if (checkin)
          u.perform_checkin! params
          flash[:notice] = "#{u.name} was checked in."
        else
          u.perform_checkout! "Admin Checkout by #{current_admin_user.email}"
          flash[:notice] = "#{u.name} was checked out."
        end

        redirect_to :action => :index
      else
        flash[:error] = "Invalid amount or user ."
        redirect_to :action => :index
      end
    end

    #  “/admin/users/credit
    # "user_id"=>"8", "amount"=>"20.00"
    collection_action :credit, :method => :post do
      u = User.find(params[:user_id])
      amt = params[:amount].to_i
      if !u.nil?
        u.add_daypass!(amt)
        flash[:notice] = "#{u.name} was credited #{amt}."
        redirect_to :action => :index
      else
        flash[:error] = "Invalid amount or user ."
        redirect_to :action => :index
      end
    end

    collection_action :charge, :method => :post do
     amt = params[:amount].to_f
     if amt > 0 and params[:email].length > 3
        card = {  :number => params[:card_number],
                  :exp_month => params[:card_month],
                  :exp_year => params[:card_year]
                }
        card[:cvc] = params[:card_code] if !params[:card_code].nil? and !params[:card_code].empty?
        charge = User.create_charge(amt, card, "#{params[:email]} - #{params[:description]} (Charged by Admin #{current_admin_user.email})")

        if !charge.paid
          flash[:error] = "Charge did not complete. #{charge.failure_message}"
        else
          flash[:notice] = "Charge was successfully processed!"

          if !params[:email].nil? and !params[:email].empty?
            AdminMailer.admin_charge_receipt(params[:email], params[:amount], params[:description], charge).deliver
          end
        end
        redirect_to :controller => :dashboard, :action => :index
      else
        flash[:error] = "Invalid amount or email."
        redirect_to :controller => :dashboard, :action => :index
      end

  end

  collection_action :message, :method => :post do
    members = User.find(:all) if params[:send_to].to_i == 0
    members = User.where("stripe_id IS NOT NULL and stripe_id != ''") if params[:send_to].to_i == 1
    members = User.where("badge IS NOT NULL and badge != ''") if params[:send_to].to_i == 2
    members = User.where("email = ?", "paul@coworkmyr.com") if params[:send_to].to_i == 3

    if !members.nil?
      AdminMailer.admin_member_message(members.collect {|u| u.email }, params[:subject], params[:message]).deliver
      flash[:notice] = "Message sent to #{members.count} members."
    else
      flash[:error] = "Did not send an email. (No members found)"
    end
    redirect_to :controller => :dashboard, :action => :index
  end

end
