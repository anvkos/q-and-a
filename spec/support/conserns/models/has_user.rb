require 'rails_helper'

shared_examples_for 'has_user' do
  it { should belong_to(:user) }
end
