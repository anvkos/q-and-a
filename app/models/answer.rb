class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }

  scope :first_best, -> { order('best DESC') }

  def mark_best
    reset_best
    self.update(best: true)
  end

  private

  def reset_best
    self.question.answers.update_all(best: false)
  end
end
