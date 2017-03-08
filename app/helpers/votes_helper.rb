module VotesHelper
  def user_can_vote_for?(entity)
    user_signed_in? && !current_user.author?(entity)
  end

  def can_delete_vote_for?(entity)
    entity.vote_user(current_user).present? && can?(:destroy, entity.vote_user(current_user))
  end

  def vote_delete_path(entity)
    can_delete_vote_for?(entity) ? vote_path(entity.vote_user(current_user)) : '#'
  end

  def class_hidden_vote_link(entity)
    'hidden' unless can?(:create, entity.votes.build)
  end

  def class_hidden_cancel_vote(entity)
    'hidden' unless can_delete_vote_for?(entity)
  end
end
