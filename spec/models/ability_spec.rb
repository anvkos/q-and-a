require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Attachment }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Vote }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:question_other_user) { create(:question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, question_other_user, user: user }
      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, question_other_user, user: user }
    end

    context 'Answer' do
      let(:answer) { create(:answer, user: user) }
      let(:answer_other_user) { create(:answer, user: other_user) }
      let(:best_answer) { create(:answer, question: question) }

      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, answer_other_user, user: user }
      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, answer_other_user, user: user }
      it { should be_able_to :mark_best, best_answer, user: user }
      it { should_not be_able_to :mark_best, answer, user: user }
      it { should_not be_able_to :mark_best, create(:answer), user: user }
    end

    context 'Attachment' do
      let(:attachment) { create(:attachment, attachable: question) }
      let(:attachment_other_user) { create(:attachment, attachable: question_other_user) }

      it { should be_able_to :create, Attachment }
      it { should be_able_to :destroy, attachment, user: user }
      it { should_not be_able_to :destroy, attachment_other_user, user: user }
    end

    context 'Vote' do
      let(:votable) { question }
      let(:vote) { create(:vote, votable: question_other_user, user: user) }
      let(:vote_other_user) { create(:vote, votable: question_other_user) }

      it { should be_able_to :create, Vote }

      it 'cannot vote author votable' do
        expect(subject.can?(:create, votable.votes.new)).to be_falsey
      end
      # короткая запись cannot vote author votable, но понятная ли?
      it { should_not be_able_to :create, votable.votes.new, user: user }

      it 'cannot double vote' do
        votable_already_vote = question_other_user.vote_up(user)
        expect(subject.can?(:create, votable_already_vote)).to be_falsey
      end

      it { should be_able_to :destroy, vote, user: user }
      it { should_not be_able_to :destroy, vote_other_user, user: user }
    end
  end
end
