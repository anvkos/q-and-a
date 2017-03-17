class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.lastday
    if @questions.any?
      mail(to: user.email, subject: 'Daily questions digest')
    end
  end
end
