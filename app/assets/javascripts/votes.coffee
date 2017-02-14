# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

addVote = ->
  $('.question, .answers').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    vote_container = '.vote-' + response.votable_type + '-' + response.votable_id
    $(vote_container + ' .rating').html(response.votable_rating)
    if response.action == 'create'
      # vote_delete_url = '/' + response.votable_type + 's/' + response.votable_id + '/votes/' + response.id
      vote_delete_url = '/votes/' + response.id
      $(vote_container + ' .vote-up').addClass('hidden')
      $(vote_container + ' .vote-down').addClass('hidden')
      $(vote_container + ' .vote-cancel').removeClass('hidden').attr('href', vote_delete_url)
    else
      $(vote_container + ' .vote-up').removeClass('hidden')
      $(vote_container + ' .vote-down').removeClass('hidden')
      $(vote_container + ' .vote-cancel').addClass('hidden').attr('href', "#")

$(document).on("turbolinks:load", addVote);
