class AuthenticationsController < ApplicationController

  before_filter :authenticate_user!

  def show
    @authentications = current_user.authentications
    respond_to do |format|
      format.js { render :json => @authentications, :except=>  [:secret, :token, :uid ] }
    end
  end

  def setcheckin
    @auth = Authentication.find(params[:id])
    @auth.checkin = params[:checkin]
    @auth.save!
    respond_to do |format|
     format.js { render :json => @auth.to_json }
    end
  end

  def destroy
    @auth = Authentication.find(params[:id])
    provider = @auth.provider
    @auth.destroy
    respond_to do |format|
      format.html { redirect_to(:action =>'index') }
      format.js { render :json => { "provider" => provider} }
    end
  end
  
end
