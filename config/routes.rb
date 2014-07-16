Lemyr::Application.routes.draw do
  wiki_root '/wiki'

  ActiveAdmin.routes(self)

  match '/admin/location_settings' => 'admin/location_settings#edit', :as => :admin_location_settings

  match '/daypass_balance(.:format)' => 'home#daypass_balance'
  #post '/daypass_balance' => 'home#daypass_balance'

  match '/membership_options(.:format)' => 'home#membership_options'
  #post '/membership_options' => 'home#membership_options'


  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    match '/login' => "devise/sessions#new", :as => :new_user_session
    #post '/login' => 'devise/sessions#create', :as => :user_session
    match '/signin' => "devise/sessions#new", :as => :new_user_session
    #post '/signin' => 'devise/sessions#create', :as => :user_session
    match '/extcheckin' => 'home#extcheckin'
    #post '/extcheckin' => 'home#extcheckin'
    match '/signup' => 'devise/registrations#new', :as => :new_user_registration
    #post '/signup' => 'devise/registrations#new', :as => :new_user_registration
    match '/checkedin' => 'home#checkedin_users'

    match 'user_root' => 'devise/registrations#edit'
  end

  authenticated :user do
    resources :authentications

    devise_scope :user do
      match '/checkin' => 'home#checkin'
      #post '/checkin' => 'home#checkin'

      match '/checkout' => 'home#checkout'
      #post '/checkout' => 'home#checkout'


      match '/users/avatar/:provider' => 'home#avatar'
      #post '/users/avatar/:provider' => 'home#avatar'

      match '/users/account/cc/delete' => 'home#credit_card_remove'
      match '/users/account/cc' => 'home#credit_card'

      #devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
      match '/auth/:provider/callback' => 'authentications#create'
      #post '/auth/:provider/callback' => 'authentications#create'

      match '/auth/checkin' => 'authentications#setcheckin'
      #post '/auth/checkin' => 'authentications#setcheckin'

      match '/signout' => 'devise/sessions#destroy', :as => :destroy_user_session
      #get '/signout' => 'devise/sessions#destroy', :as => :destroy_user_session
      #post '/signout' => 'devise/sessions#destroy', :as => :destroy_user_session

      match '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
      #post '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'

      match '/auth/:provider/callback' => 'sessions#auth_callback', :as => :auth_callback
      #post '/auth/:provider/callback' => 'sessions#auth_callback', :as => :auth_callback
    end

    root :to => "home#index"
  end

  match '/avatar/:user' => "home#avatar"
  #post '/avatar/:user' => "home#avatar"

  match '/headlines' => "home#headlines"
  #post '/headlines' => "home#headlines"

  match '/stripe' => "stripe_events#incoming"
  #post '/stripe' => "stripe_events#incoming"

  match '/agreement' => "home#agreement"
  #post '/agreement' => "home#agreement"

  match '/lobby_messages' => 'home#lobby_messages'
  #post '/lobby_messages' => 'home#lobby_messages'

  match '/meetups' => 'home#meetups'
  #post '/meetups' => 'home#meetups'

  match '/lobby' => "home#display"
  #post '/lobby' => "home#display"

  authenticate :user do
    match '/purchase' => 'home#purchase'
    #post '/purchase' => 'home#purchase'

    match '/transfer/:code' => 'home#transfer'
    post '/transfer' => 'home#transfer'

    match '/directory' => 'home#user_directory'
    #post '/directory' => 'home#user_directory'

    match '/billing' => 'home#billing'
    #post '/billing' => 'home#billing'

    match '/status' => 'home#status'
    #post '/status' => 'home#status'

    root :to => "home#index"
  end
end
