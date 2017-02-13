class Vote < ApplicationRecord
  include HasUser
  belongs_to :votable, polymorphic: true

  validates :votable_id, :votable_type, :rating, presence: true
  validates :rating, inclusion: { in: [-1, 1],
    message: "%{value} is not included in the set" }
end
