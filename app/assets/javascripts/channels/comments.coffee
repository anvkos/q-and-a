comments_channel = ->
  App.cable.subscriptions.create {
    channel: "CommentsChannel"
  },

  received: (data) ->
    unless gon.user_id == data.comment.user_id
      comments_container = '.comments-' + data.commentable_type + '-' + data.comment.commentable_id
      $(comments_container + ' .comments-list').append(JST['templates/comment'](content: data.comment.content))

$(document).on("turbolinks:load", comments_channel);
