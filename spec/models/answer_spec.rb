require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'association' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'validation' do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10) }
  end
end
