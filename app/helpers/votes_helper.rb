module VotesHelper
  def user_can_vote_for?(entity)
    user_signed_in? && !current_user.author?(entity)
  end

  def vote_delete_path(entity)
    entity.vote_user(current_user).present? ? vote_path(entity.vote_user(current_user)) : '#'
  end

  def class_hidden_vote_link(entity)
    'hidden' if entity.vote_user(current_user).present?
  end

  def class_hidden_cancel_vote(entity)
    'hidden' if entity.vote_user(current_user).nil?
  end
end
