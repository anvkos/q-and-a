require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:question) { create(:question) }
  let!(:vote_params) { { question_id: question, votable_type: question.class.name, rating: 'up', format: :json } }

  describe 'POST #create' do
    context 'Authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new vote in the database' do
          expect { post :create, params: vote_params }.to change(question.votes, :count).by(1)
        end

        it 'render success' do
          post :create, params: vote_params
          question.reload
          data = JSON.parse(response.body)
          expect(response).to have_http_status :success

          expect(data['id']).to eq assigns(:vote).id
          expect(data['votable_rating']).to eq question.rating
          expect(data['votable_type']).to eq question.class.name.underscore
          expect(data['votable_id']).to eq question.id
          expect(data['action']).to eq 'create'
          expect(data['message']).to eq 'Your vote has been accepted!'
        end
      end

      context 'with invalid attributes' do
        let(:votable_type_missing) { { question_id: question, rating: 'up', format: :json } }
        let(:invalid_votable_type) { { question_id: question, votable_type: 'Trulala', rating: 'up', format: :json } }

        context 'does not save the vote' do
          it 'votable type missing' do
            expect do
              post :create, params: votable_type_missing
            end.to_not change(Vote, :count)
          end

          it 'invalid votable type' do
            expect do
              post :create, params: invalid_votable_type
            end.to_not change(Vote, :count)
          end
        end

        context 'renders error' do
          it 'votable type missing' do
            post :create, params: votable_type_missing
            data = JSON.parse(response.body)
            expect(response).to have_http_status :unprocessable_entity
            expect(data['error']).to eq 'Error save'
            expect(data['error_message']).to eq 'Not the correct vote data!'
          end

          it 'invalid votable type' do
            post :create, params: invalid_votable_type
            data = JSON.parse(response.body)
            expect(response).to have_http_status :unprocessable_entity
            expect(data['error']).to eq 'Error save'
            expect(data['error_message']).to eq 'Not the correct vote data!'
          end
        end
      end

      context 'User is author votable'
    end

    context 'Non-authenticated user' do
      it 'tries vote' do
        expect do
          post :create, params: vote_params
        end.to_not change(Vote, :count)
      end
    end
  end
end
