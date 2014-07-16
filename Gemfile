source 'https://rubygems.org'

gem 'rails', '3.2.19'
gem 'unicorn'
gem 'dotenv-rails'

# Core Gems
gem 'inherited_resources'
gem 'devise', '~> 3.2.4'
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'switch_user'
gem 'paperclip', '~> 3.0'
gem 'aws-sdk' # For S3 uploads.

# Social Integrations
gem 'twitter'
gem 'linkedin'
gem 'koala' # Facebook
gem 'google_plus'
gem 'foursquare-api', github: 'CubicPhase/foursquare-api', branch: 'master'
gem 'hominid' # MailChimp
gem 'rMeetup', github: 'mbgeek/rmeetup', branch: 'master'

# OAuth Social Integrations
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
gem 'omniauth-foursquare'
gem 'omniauth-google-oauth2'
gem 'oauth2'

# Payment Integrations
gem 'stripe'
gem 'stripe_event'

# Wiki
gem 'RedCloth'
gem 'irwi', github: 'alno/irwi'

# Assets
gem 'coffee-rails', '~> 3.2.1'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.0.3'
gem 'bootstrap-sass', '~> 2.2.2.0'
gem 'font-awesome-sass-rails'
gem 'sass-rails',   '~> 3.2.3'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'tinymce-rails'
gem 'google-webfonts', github: 'weilu/Google-Webfonts-Helper'
gem 'google-analytics-rails'

group :development do
  gem 'capistrano-rails'
  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
end

# Configuration Specific Gems
group :rollbar do
  gem 'rollbar'
end

group :mandrill do
  gem 'mandrill-api'
end

group :postgres do
  gem 'pg'
end
