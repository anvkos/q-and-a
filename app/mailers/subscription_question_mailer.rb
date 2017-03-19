class SubscriptionQuestionMailer < ApplicationMailer
  def notify(user, answer)
    @answer = answer
    @greeting = "Hi #{user.email}!"
    mail(to: user.email, subject: "New answer to the question #{@answer.question.title}")
  end
end
