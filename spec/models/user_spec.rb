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
end
