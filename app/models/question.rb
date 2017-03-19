class Question < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true, length: { minimum: 10 }

  scope :lastday, -> { where(created_at: 1.day.ago..Time.now) }

  after_create :subscribe

  private

  def subscribe
    subscriptions.create(user_id: user_id)
  end
end
