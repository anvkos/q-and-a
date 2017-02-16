class Vote < ApplicationRecord
  include HasUser
  belongs_to :votable, polymorphic: true

  validates :rating, presence: true
  validates :rating, inclusion: { in: [-1, 1],
    message: "%{value} is not included in the set" }
end
