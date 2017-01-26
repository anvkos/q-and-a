require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validation' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '#author?' do
    it 'returns true' do
      user_id = rand(1..100)
      user = create(:user, id: user_id)
      entity = double('Entity')
      allow(entity).to receive_messages(user_id: user_id)
      expect(user.author?(entity)).to be_truthy
    end

    it 'returns false' do
      user_id = rand(1..100)
      other_id = rand(200..300)
      user = create(:user, id: user_id)
      entity = double('Entity')
      allow(entity).to receive_messages(user_id: other_id)
      expect(user.author?(entity)).to be_falsey
    end
  end
end
