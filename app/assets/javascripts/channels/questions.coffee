questions_channel = ->
  App.cable.subscriptions.create "QuestionsChannel",
    received: (data) ->
      $('section.questions').append(JST['templates/question'](data))

$(document).on("turbolinks:load", questions_channel);
