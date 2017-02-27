module Polymorphic
  extend ActiveSupport::Concern

  protected

  def set_parent!
    parent_type = request.fullpath.split('/').second.singularize
    parent_id = params["#{parent_type}_id"]
    @parent = parent_type.classify.constantize.find(parent_id)
  end
end
