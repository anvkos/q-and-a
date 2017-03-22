require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end

    context 'without get params' do
      before { get :show }

      it 'render template' do
        expect(response).to render_template :show
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with searches params' do
      let(:search_params) { { q: 'search text', scopes: ['all'] } }

      it 'call search' do
        params = ActionController::Parameters.new(search_params).permit!
        expect(Search).to receive(:do).with(params)
        get :show, params: search_params
      end

      it 'renders template' do
        get :show, params:  search_params
        expect(response).to render_template :show
      end
    end
  end
end
