class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params['commentable_type']}_#{params['commentable_id']}_comments"
  end
end
