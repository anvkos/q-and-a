require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'has_user'
  it_behaves_like 'attachable'

  describe 'association' do
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validation' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_length_of(:title).is_at_least(10) }
    it { should validate_length_of(:body).is_at_least(10) }
  end
end
