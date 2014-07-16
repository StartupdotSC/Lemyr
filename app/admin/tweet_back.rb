ActiveAdmin.register TweetBack do
    menu :label => "Auto Tweet Backs", :parent => "Location", :priority => 10
    actions :index, :edit, :update, :new, :create, :destroy
    config.filters = false
    config.batch_actions = false

    index :download_links => false do |settings|
        column :tweet, :label => "Tweet"
        actions
    end

    form :partial => "form"
end
