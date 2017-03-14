require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    context 'comment for question' do
      let(:commentable) { create(:question) }

      it_behaves_like 'Create Comment'
    end

    context 'comment for answer' do
      let(:commentable) { create(:answer) }

      it_behaves_like 'Create Comment'
    end
  end
end
