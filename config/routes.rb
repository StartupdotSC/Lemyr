Lemyr::Application.routes.draw do
  ActiveAdmin.routes(self)

  get '/avatar/:user' => "home#avatar"
  get '/agreement' => "home#agreement"

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  authenticated :user do
    resources :authentications, only: [:show, :destroy]
    get '/auth/checkin' => 'authentications#setcheckin'

    post '/checkin' => 'home#checkin'
    get '/checkout' => 'home#checkout'

    get '/purchase' => 'home#purchase'
    post '/purchase' => 'home#purchase'

    get '/transfer/:code' => 'home#transfer'
    post '/transfer' => 'home#transfer'

    get '/users/avatar/:provider' => 'home#avatar'

    post '/users/account/cc/delete' => 'home#credit_card_remove'
    post '/users/account/cc' => 'home#credit_card'

    get '/directory' => 'home#user_directory'
    get '/billing' => 'home#billing'
    get '/status' => 'home#status'
  end

  # API JSONy Things - Mostly for Dashboard
  get '/lobby' => "home#display" # Lobby Display
  get '/daypass_balance' => 'home#daypass_balance'
  get '/membership_options(.:format)' => 'home#membership_options'
  get '/checkedin' => 'home#checkedin_users'
  get '/lobby_messages' => 'home#lobby_messages'
  get '/meetups' => 'home#meetups'

  # Stripe Webhook
  post '/stripe' => "stripe_events#incoming"

  root to: 'home#index'
end
