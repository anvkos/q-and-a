require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes) }
  it { should accept_nested_attributes_for(:votes) }
end
