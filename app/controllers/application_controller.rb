class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :check_user_password
  before_filter :check_location_settings

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :company_name]
    devise_parameter_sanitizer.for(:account_update) << [:name, :company_name, :phone, :membership_id, :avatar_attached]
  end

  def check_user_password
    if !current_user.nil? and !controller_name.eql?"registrations" and !current_user.has_password?
      flash.notice = "Please set your password and email before continuing."
      redirect_to "/users/edit"
    end
  end

  def check_location_settings
    if LocationSettings.get.nil? && !(params[:controller] =~ /^(admin|active_admin)/)
      raise Exception
      render :text => "Gah! You need to do some <a href='/admin'>admin set up</a>!"
      return
    end
  end
end
