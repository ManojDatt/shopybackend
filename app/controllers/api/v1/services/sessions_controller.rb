class Api::V1::Services::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  prepend_before_action :require_no_authentication, :only => [:create]
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :authenticate_user_with_token!, only: [:logout, :update]
  respond_to :json

  def create
    resource = User.find_by(:email=>customer_params[:email])
    if resource.present?
      if resource.valid_password?(customer_params[:password])
        sign_in("customer", resource)
        render :json=> {:auth_token=>resource.authentication_token, :details=>resource.as_json, new_user: false , code: 200, message: "Login successfully !!"}
        return

      else
        render :json => {:auth_token=>"", :details=>{}, new_user: false, code: 404, message: "Invalid login details !!"}
        return
      
      end
    else
      resource = User.new(email:customer_params[:email], name: customer_params[:email], password: customer_params[:password])
      if resource.save
        sign_in("customer", resource)
        render :json => {:auth_token=>resource.authentication_token, :details=>resource.as_json,  new_user: true ,code: 200, message: "Login successfully !!"}
        return
      else
        warden.custom_failure!
        render :json => {auth_token:"", details: {}, code: 500, new_user: false, message: resource.errors.full_messages.join(", ")}
        return
      end
    end
    invalid_login_attempt
  end
  
  def logout
    @user.update(authentication_token: nil)
    sign_out(@user)
    render json: {message: "Logout successfully", code: 200}
  end

  def update
    if @user.update(customer_params)
      render :json => {:auth_token=>@user.authentication_token, :details=>@user.as_json, code: 200, message: "Profile updated successfully."}
    else
      warden.custom_failure!
      render :json => { :auth_token=>@user.authentication_token ,details: @user.as_json, code: 500, :message=> @user.errors.full_messages.map{ |msg| msg}.join}
    end
  end



  private
  def ensure_params_exist
    return unless params[:user].blank?
    render :json=> {auth_token:"", details: {}, code: 500, new_user: false, message: "Opps, You are missing parameters !!"}
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {auth_token:"", details: {}, code: 500, new_user: false, message: "Invalid login details."}
  end

  def customer_params
    params.require(:user).permit(:email, :password)
  end


  def authenticate_user_with_token!
    customer_auth_token = request.headers['HTTP_AUTHORIZATION'].presence
    @user = User.find_by_authentication_token(request.headers['HTTP_AUTHORIZATION'])

    if @user && Devise.secure_compare(@user.authentication_token, customer_auth_token)
        @user
        return
    else
      render json: {message: "Invalid access token passed !", code: 403}
    end
  end


end