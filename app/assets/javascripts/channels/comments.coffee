comments_channel = ->
  comments_container = $('.comments');
  commentable_type = comments_container.data('commentable-type')
  commentable_id = comments_container.data('commentable-id')
  App.cable.subscriptions.create {
    channel: "CommentsChannel"
    commentable_type: commentable_type
    commentable_id: commentable_id
  },

  received: (data) ->
    unless gon.user_id == data.comment.user_id
      comments_container = '.comments-' + commentable_type + '-' + commentable_id
      $(comments_container + ' .comments-list').append(JST['templates/comment'](content: data.comment.content))

$(document).on("turbolinks:load", comments_channel);
