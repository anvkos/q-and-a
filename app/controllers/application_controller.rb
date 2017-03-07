require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { error: 'resource_forbidden' }, status: :forbidden }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  # check_authorization

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
