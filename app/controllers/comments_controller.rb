class CommentsController < ApplicationController
  include Contexted
  include Serialized

  before_action :authenticate_user!
  before_action :set_context!, only: [:create]

  after_action :publish_comment, only: [:create]

  def create
    @comment = @context.comments.new(comment_params)
    if @comment.save
      render_success(prepare_data(@comment), 'create', 'Your comment has been added!')
    else
      render_error(:unprocessable_entity, 'Error save', 'Not the correct comment data!')
    end
  end

  private

  def prepare_data(item)
    item.slice(:id, :commentable_id, :content)
        .merge(commentable_type: item.commentable_type.underscore)
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id)
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
