require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'association' do
    it { should belong_to(:question) }
  end

  describe 'validation' do
    it { should validate_presence_of :body }
  end
end
