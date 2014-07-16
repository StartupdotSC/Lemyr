SwitchUser.setup do |config|
  config.controller_guard = lambda { |current_user, request| true }
  config.view_guard = lambda { |current_user, request| true }
  config.redirect_path = lambda { |request, params| '/users/edit' }
  config.available_users_names = { :user => :name }
end