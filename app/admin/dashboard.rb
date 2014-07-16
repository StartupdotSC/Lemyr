require 'stripe'

ActiveAdmin.register_page "Dashboard" do

  LocationSettings.refresh
  
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }
  
  sidebar "Member Status", :partial => "checkin_user_sidebar", :only => :index
  sidebar :credit_card_charge if !LocationSettings.get.nil? and !LocationSettings.get.integration(:stripe).nil?
  
  content :title => proc{ I18n.t("active_admin.dashboard") } do
       
       if LocationSettings.get.nil?
          section do
           span "<strong>No Location Settings have been set!</strong> <a href='/admin/location_settings/new'>Create Settings</a>.</em>".html_safe 
             br
          end 
       elsif LocationSettings.get.integration(:stripe).nil?
          section do
           span "<strong>No Stripe integrations have been set.</strong> <a href='#{new_admin_api_integration_path(:provider => :stripe)}'>Set Up Stripe</a>.</em>".html_safe 
             br
          end 
       elsif LocationSettings.get.integration(:amazon_s3).nil?
          section do
           span "<strong>No Amazon S3 credentials have been set.</strong> <a href='#{new_admin_api_integration_path(:provider => :amazon_s3)}'>Set Up Amazon</a>.</em>".html_safe 
             br
          end 
       elsif LocationSettings.get.integration(:mandrill).nil?
          section do
           span "<strong>No Mandrill credentials have been set.</strong> <a href='#{new_admin_api_integration_path(:provider => :mandrill)}'>Set Up Mandrill</a>.</em>".html_safe 
             br
          end 
       else
         section do
           if LocationSettings.first.freeday 
             span "Free Day is active!  <em>No more freebies? <a href='#{edit_admin_location_setting_path(LocationSettings.first)}'>Change Settings</a>.</em>".html_safe 
             br
           end 

           panel "Currently Checked In Members" do
              members = UserStatus.get_currently_checked_in

              if members.nil?
                em "Aw shucks. Nobody is checked in yet."
              else
                members.each do |status|
                  user = status.user
                  status = user.get_last_status
                  div :class => "user_box" do
                    h3 link_to(user.name, admin_user_path(user))
                    div status_tag(status.checkin? ? "Checked In" : "Checked Out", status.checkin ? :ok : :warn) if !status.nil?
                    div(:class => "member-avatar", :style => "background-image:url(#{user.avatar_attached.url(:thumb)});")
                    ul do
                      li "<a href='/admin/users/checkin?user_id=#{user.id}&checkin=true'>Check Out</a>".html_safe
                    end
                  end
                end
                br :style => "clear: both;"
              end
           end

           panel "Common Tasks" do
               h3 link_to("Add New Member", new_admin_user_path)
               em "Create a profile for a member and assign their badge..."
               hr
               h3 link_to("Edit Lobby Messages", admin_lobby_messages_path)
               em "Change up the lobby display..."
               hr
               h3 link_to("Location Settings", edit_admin_location_setting_path(LocationSettings.first))
               em "Change day pass pricing, mark day as free for all..."
            end
         end
     

         section do
            panel "Message Members" do
              render :partial => "message_members"
            end
         end
      end

  end # content

end
