ActiveAdmin.register CheckinStatus do
    menu :label => "Check-In Options", :parent => "Location", :priority => 10
    actions :index, :edit, :update
    config.filters = false
    config.batch_actions = false

    index do
        column :label, :class => :checkinstatus_label
        column :id
        actions
    end
end
