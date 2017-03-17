require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it_behaves_like 'has_user'

  describe 'association' do
    it { should belong_to(:question) }
  end
end
