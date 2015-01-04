source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'unicorn'
gem 'pg'
gem 'dotenv-rails'
gem 'protected_attributes' # Needed until we migrate to strong_params

# Core Gems
gem 'devise', '~> 3.4.1'
gem 'switch_user'
gem 'paperclip', '~> 3.0'
gem 'aws-sdk' # For S3 uploads.
gem 'rollbar'
gem 'mandrill-api'
gem 'activeadmin', github: 'activeadmin'
gem 'inherited_resources', github: 'josevalim/inherited_resources', branch: 'rails-4-2'

# Social Integrations
gem 'twitter', '~> 4.8'
gem 'linkedin'
gem 'koala' # Facebook
gem 'google_plus'
gem 'foursquare-api', github: 'CubicPhase/foursquare-api', branch: 'master', require: 'foursquare'
gem 'hominid' # MailChimp
gem 'rMeetup', '~> 2.0.1'

# OAuth Social Integrations
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
gem 'omniauth-foursquare'
gem 'omniauth-google-oauth2'
gem 'oauth2'

# Payment Integrations
gem 'stripe'

# Assets
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.0.3'
gem 'bootstrap-sass', '~> 2.2.2.0'
gem 'font-awesome-sass-rails'
gem 'sass-rails',   '~> 4.0.3'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'tinymce-rails'
gem 'google-webfonts', github: 'weilu/Google-Webfonts-Helper'
gem 'google-analytics-rails'

group :development do
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  gem 'web-console', '~> 2.0'
  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  gem 'capistrano-bundler', '~> 1.1.3', require: false
  gem 'capistrano3-unicorn', require: false
end
