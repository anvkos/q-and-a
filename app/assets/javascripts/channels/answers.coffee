answers_channel = ->
  question_id = $('.answers').data('question-id')
  App.cable.subscriptions.create {
    channel: "AnswersChannel"
    question_id: question_id
  },

  received: (data) ->
    unless gon.user_id == data.answer.user_id
      $('section.answers').append(JST['templates/answer'](data))

$(document).on("turbolinks:load", answers_channel);
