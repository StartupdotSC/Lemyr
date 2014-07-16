ActiveAdmin.register LobbyMessage do
    menu :label => "Lobby Display", :parent => "Location", :priority => 1
    actions :index, :edit, :update, :new, :create, :destroy
    config.filters = false

    index :download_links => false do |message|
        selectable_column
        column :text
        actions
    end

    form do |f|
      f.inputs do
        f.input :text, :as => :text, :label => "Message", :input_html => {:class => 'tinymce'}
      end
      f.actions
    end
end
