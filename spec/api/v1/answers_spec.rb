require 'rails_helper'

RSpec.describe 'Answers API' do
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let(:answer) { answers.last }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body best created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge!(options)
    end
  end

  describe 'GET #show' do
    let!(:answer) { create(:answer) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let!(:comment) { comments.last }
      let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
      let!(:attachment) { attachments.last }
      let!(:parent_path) { 'answer' }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body best created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it_behaves_like 'API Attachable'
      it_behaves_like 'API Commentable'
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge!(options)
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          expect(response).to be_created
        end

        it 'saves the new answer in the database' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }.to change(Answer, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'does not save the answer' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token } }.not_to change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge!(options)
    end
  end
end
