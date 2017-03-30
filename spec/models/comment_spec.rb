require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'has_user'

  describe 'association' do
    it { should belong_to(:commentable).touch(true) }
  end

  describe 'validation' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(10) }
    it { should validate_length_of(:content).is_at_most(1000) }
  end
end
