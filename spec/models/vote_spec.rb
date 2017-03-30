require 'rails_helper'

RSpec.describe Vote, type: :model do
  it_behaves_like 'has_user'

  describe 'association' do
    it { should belong_to(:votable).touch(true) }
  end

  describe 'validation' do
    it { should validate_presence_of(:rating) }
    it { should validate_inclusion_of(:rating).in_array([1, -1]) }
  end
end
