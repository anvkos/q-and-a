require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    include Serialized
    def create
      if params[:payload].present?
        render_success(params, 'create', 'Your payload saved!')
      else
        render_error(:unprocessable_entity, 'Error save', 'Not the correct payload data!')
      end
    end
  end

  describe 'POST #create' do
    let(:params) { { payload: 'Payload data' } }

    context 'with valid attributes' do
      before { post :create, params: params.merge(format: :json) }

      it 'returns success status' do
        expect(response).to have_http_status :success
      end

      it 'render success json' do
        data = JSON.parse(response.body)
        expect(response).to have_http_status :success
        expect(data['payload']).to eq params[:payload]
        expect(data['action']).to eq 'create'
        expect(data['message']).to eq 'Your payload saved!'
      end
    end

    context 'with invalid attributes' do
      let!(:invalid_params) { {} }

      before { post :create, params: invalid_params.merge(format: :json) }

      it 'returns 422 status' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'render error json' do
        data = JSON.parse(response.body)
        expect(data['error']).to eq 'Error save'
        expect(data['error_message']).to eq 'Not the correct payload data!'
      end
    end
  end
end
