require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it_behaves_like 'has_user'

  describe 'validation' do
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
  end
end
