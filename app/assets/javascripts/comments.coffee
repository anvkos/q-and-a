addComment = ->
  $('.question, .answers').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    comments_container = '.comments-' + response.commentable_type + '-' + response.commentable_id;
    $(comments_container + ' .comments-list').append(JST['templates/comment'](response));
    $(comments_container + ' #comment_content').val('');

$(document).on("turbolinks:load", addComment);
