class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Attachment, Comment]
    can :create, Vote do |vote|
      !user.author?(vote.votable) && vote.votable.vote_user(user).nil?
    end
    can :create, Subscription do |subscription|
      subscription.question.subscriptions.find_by(user_id: user.id).nil?
    end
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Vote, Subscription], user_id: user.id
    can :destroy, Attachment, attachable: { user_id: user.id }
    can :mark_best, Answer do |answer|
      user.author?(answer.question) && !answer.best
    end
  end
end
