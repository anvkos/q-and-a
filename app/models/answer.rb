class Answer < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable
  belongs_to :question

  validates :body, presence: true, length: { minimum: 10 }

  scope :first_best, -> { order('best DESC') }

  after_create :notify

  def mark_best
    ActiveRecord::Base.transaction do
      question.answers.where(best: true).find_each { |answer| answer.update!(best: false) }
      update!(best: true)
    end
  end

  private

  def notify
    SubscriptionQuestionJob.perform_later(self)
  end
end
