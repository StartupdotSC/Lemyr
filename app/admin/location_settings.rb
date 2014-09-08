ActiveAdmin.register LocationSettings do
  menu :label => "Location Settings", :parent => "Location", :priority => 1
  actions :index, :edit, :update, :create
  config.filters = false
  config.batch_actions = false

  controller do
    def index
      if !LocationSettings.get.nil?
        redirect_to edit_admin_location_setting_path(LocationSettings.get)
        return
      end
    end
  end

  index :download_links => false do |settings|
    column :name, :label => "Location"
    actions
  end


  form do |f|
    f.inputs do
      f.input :freeday, :label => "Free For All (No daypass required to check in)"
      f.input :name
      f.input :corporate_name
      f.input :logo_url, :label => "Logo URL"
      f.input :main_site_url, :label => "Main site URL for the space"
      f.input :membership, :label => "Default new user membership", collection: Membership.where("stripe_id IS NULL OR stripe_id = ''")
      f.input :membership_plans_url, :label => "URL to Membership Plans info"
      f.input :location_description, :label => "Location description"
      f.input :daypass_price, :label => "Daypass Retail ($)"
      f.input :daypass_price3, :label => "Daypass 3-Pack Retail ($)"
      f.input :daypass_price5, :label => "Daypass 5-Pack Retail ($)"
      f.input :daypass_discount, :label => "% Off Daypass for Members"
      #f.input :mailer_host, :label => "Domain for mailers"
      f.input :sender_email, :label => "System Email Sender"
      f.input :notification_email, :label => "System Notice Receiver"
    end

    f.inputs 'User Agreement' do
      f.input :user_agreement, label: 'User Agreement', input_html: { class: 'tinymce' }
    end

    f.actions
  end
end
