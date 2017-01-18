require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'association' do
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validation' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
end
