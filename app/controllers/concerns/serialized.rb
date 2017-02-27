module Serialized
  extend ActiveSupport::Concern

  def render_success(data, action, message)
    render json: data.merge(action: action, message: message)
  end

  def render_error(status, error = 'error', message = 'message')
    render json: { error: error, error_message: message }, status: status
  end
end
