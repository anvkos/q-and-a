class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_provider

  def facebook
  end

  def twitter
  end

  private

  def sign_in_provider
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      flash[:notice] = 'For complete the registration your need to confirm email!'
      render 'users/confirmation_email', user: @user
    end
  end
end
