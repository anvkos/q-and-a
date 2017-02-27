module Contexted
  extend ActiveSupport::Concern

  protected

  def set_context!
    context_type = request.fullpath.split('/').second.singularize
    context_id = params["#{context_type}_id"]
    @context = context_type.classify.constantize.find(context_id)
  end
end
