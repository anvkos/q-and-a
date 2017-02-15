module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy

    accepts_nested_attributes_for :votes
  end

  def rating
    votes.sum(:rating)
  end

  def vote_user(user)
    votes.find_by(user: user)
  end
end
