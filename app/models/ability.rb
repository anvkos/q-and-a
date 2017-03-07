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
    can :create, [Question, Answer, Attachment]
    can :create, Vote do |vote|
      vote.votable.user != user
    end
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer, Vote], user: user
    can :destroy, Attachment, attachable: { user_id: user.id }
    can :mark_best, Answer do |answer|
      answer.question.user == user && !answer.best
    end
  end
end
