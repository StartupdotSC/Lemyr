class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    auth = request.env["omniauth.auth"]

    if auth['credentials']['token'].nil?
      flash[:error] = "Social connnection could not be made."
      redirect_to "/users/edit"
      return
    end

    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if authentication and !authentication.user.nil?
      # Authentication found, sign the user in.
      if current_user.nil?
        authentication.update_omniauth(auth)
        if authentication.user.name.nil?
          flash.notice = "Welcome! Please finish your profile."
        else
          flash.notice = "Welcome, #{authentication.user.name}."
        end
        sign_in authentication.user, :bypass => true
        begin
          redirect_to request.env['omniauth.origin']
        rescue
          redirect_to :root
        end
      else
        flash.notice = "That social connection to your profile already exists."
        begin
          redirect_to request.env['omniauth.origin']
        rescue
          redirect_to :root
        end
      end
      
    else
      # An authentication was not found.
      # if this authentication has an email, try to find the user that way
      user = current_user
      email = auth['extra']['raw_info']['email'] if !auth['extra']['raw_info'].nil?

      # see if this user email attached to a user account exists already
      if (user.nil? && email != nil)
        user = User.find_by_email(email)
      end

      if user != nil
         flash.notice = "We've connected this #{auth['provider'].to_s.titleize} account to your existing user account for " + user.email
      else
        #flash.notice = "No user asscociated with that social media account could be found. Please log in with your email then connect your social profiles to enable social sign-in."
        #session[:email] = email;
        name = "#{auth['extra']['raw_info']['name']}" if name.nil?
        name = "#{auth['extra']['raw_info']['first_name']} #{auth['extra']['raw_info']['last_name']}" if name.nil?
        email = "Enter a valid email address" if email.nil?

        #puts auth.to_yaml 

        #tempToken = "#{auth['provider'].to_s.titleize}-#{Devise.friendly_token.first(6)}@youremailhere.com";
        user = User.new(:email => email, :name => name)
        user.apply_omniauth(auth)
        if user.save(:validate => false)
          sign_in_and_redirect(user)
          return
        end
      end

      begin
        user.apply_omniauth(auth)
        if user.save(:validate => false)
           sign_in_and_redirect(user)
        else
          flash.error = "Error while creating a user account. Please try again."
          redirect_to "/users/edit"
        end
      rescue ActiveRecord::RecordNotUnique
        flash.error = "Error (74) Please try logging in with another service or your account credentials."
        redirect_to "/users/edit"
      end
    end
  end

  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :linkedin, :all
  alias_method :google_oauth2, :all
  alias_method :foursquare, :all

end