ActiveAdmin.register ApiIntegration do
    menu :label => "Service Integrations", :parent => "Location", :priority => 10
    actions :index, :edit, :update, :new, :create, :destroy
    config.filters = false
    config.batch_actions = false

    index :download_links => false do |settings|
        LocationSettings.refresh
        column :provider, :label => "Service" do |api|
            api.provider.titlecase
        end
        actions
    end

    form :partial => "form"
end
