require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:entity) { create(model.to_s.underscore.to_sym) }

  it { should have_many(:votes) }
  it { should accept_nested_attributes_for(:votes) }

  describe '#rating' do
    it 'returns sum rating' do
      votes = create_list(:vote, 2, votable: entity)
      expect(entity.rating).to eq votes.first.rating + votes.last.rating
    end
  end

  describe '#vote_user' do
    let(:user) { create(:user) }

    it 'return users vote' do
      expected_vote = create(:vote, votable: entity, user: user)
      expect(entity.vote_user(user)).to eq expected_vote
    end
  end
end
