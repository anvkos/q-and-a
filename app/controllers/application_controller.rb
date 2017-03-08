require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { error: 'forbidden', error_message: exception.message }, status: :forbidden }
      format.js   { render '/errors/error_forbidden', status: :forbidden, content_type: 'text/html' }
    end
  end

  check_authorization unless :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
