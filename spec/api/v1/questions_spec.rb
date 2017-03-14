require 'rails_helper'

RSpec.describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:comment) { comments.last }
      let!(:attachments) { create_list(:attachment, 2, attachable: question) }
      let!(:attachment) { attachments.last }
      let!(:parent_path) { 'question' }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it_behaves_like 'API Attachable'
      it_behaves_like 'API Commentable'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token }
          expect(response).to be_created
        end

        it 'saves the new question in the database' do
          expect { post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'does not save the question' do
          expect { post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token } }.not_to change(Question, :count)
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end
end
