ActiveAdmin.register UserStatus do
    menu :label => "Member Status Log", :parent => "Members", :priority => 10
    index do
        column :user, :sortable => :user_id do |checkin|
            b link_to(checkin.user.name, edit_admin_user_path(checkin.user))
        end
        column "Current Avatar", :sortable => :user_id do |checkin|
            div(:class => "member-avatar", :style => "background-image:url(#{checkin.user.avatar_attached.url(:thumb)});")
        end
        column :checkin_status, :sortable => :checkin_status_id
        column :comment
        column :created_at, :label => "Date/Time"
        actions
    end
end
