class Question < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true, length: { minimum: 10 }
end
