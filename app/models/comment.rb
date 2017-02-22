class Comment < ApplicationRecord
  include HasUser
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }
end
