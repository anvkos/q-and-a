require 'rails_helper'

shared_examples_for 'commentable' do
  let(:model) { described_class }
  let(:entity) { create(model.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  it { should have_many(:comments) }
end
