class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, dependent: :destroy

  validates :title, :body, presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments
end
