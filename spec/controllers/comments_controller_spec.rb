require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let!(:comment_params) { { comment: attributes_for(:comment), question_id: question, format: :json } }

  describe 'POST #create' do
    context 'Authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new comment in the database' do
          expect do
            post :create, params: comment_params
          end.to change(question.comments, :count).by(1)
        end

        it 'comment belongs to the user' do
          post :create, params: comment_params
          expect(Comment.last.user).to eq @user
        end

        it 'render success json' do
          post :create, params: comment_params
          comment = question.comments.last
          data = JSON.parse(response.body)

          expect(response).to have_http_status :success
          expect(data['id']).to eq assigns(:comment).id
          expect(data['content']).to eq comment.content
          expect(data['commentable_type']).to eq question.class.name.underscore
          expect(data['commentable_id']).to eq question.id
          expect(data['message']).to eq 'Your comment has been added!'
        end
      end

      context 'with invalid attributes' do
        let!(:invalid_comment_params) { { question_id: question, comment: { content: 'text' }, format: :js } }
        it 'does not save the comment' do
          expect do
            post :create, params: invalid_comment_params
          end.to_not change(Comment, :count)
        end

        it 'render error json' do
          post :create, params: invalid_comment_params
          data = JSON.parse(response.body)
          expect(response).to have_http_status :unprocessable_entity
          expect(data['error']).to eq 'Error save'
          expect(data['error_message']).to eq 'Not the correct comment data!'
        end
      end
    end

    context 'Non-authenticated user' do
      it 'tries to comment' do
        expect do
          post :create, params: comment_params
        end.to_not change(Comment, :count)
      end
    end
  end
end
