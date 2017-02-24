class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable!, only: [:create]

  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render_success(@comment, 'create', 'Your comment has been added!')
    else
      render_error(:unprocessable_entity, 'Error save', 'Not the correct comment data!')
    end
  end

  private

  def render_success(item, action, message)
    render json: item.slice(:id, :commentable_id, :content)
                      .merge(
                        commentable_type: item.commentable_type.underscore,
                        action: action,
                        message: message
                      )
  end

  def render_error(status, error = 'error', message = 'message')
    render json: { error: error, error_message: message }, status: status
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_commentable!
    commentable_type = request.fullpath.split('/').second.singularize
    commentable_id = params["#{commentable_type}_id"]
    @commentable = commentable_type.classify.constantize.find(commentable_id)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments",
      comment: @comment,
      commentable_type: @comment.commentable_type.underscore
    )
  end
end
