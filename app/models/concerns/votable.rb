module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:rating)
  end

  def vote_user(user)
    votes.find_by(user: user)
  end

  def vote_up(user)
    votes.create(user: user, rating: 1)
  end

  def vote_down(user)
    votes.create(user: user, rating: -1)
  end
end
