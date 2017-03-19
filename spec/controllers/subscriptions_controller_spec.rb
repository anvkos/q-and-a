require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:subscription_params) { { question_id: question, format: :js } }

  describe 'POST #create' do
    context 'Authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new subscription in the database' do
          expect { post :create, params: subscription_params }.to change(Subscription, :count).by(1)
        end

        it 'subscription belongs to the user' do
          post :create, params: subscription_params
          expect(Subscription.last.user).to eq @user
        end

        it 'render template' do
          post :create, params: subscription_params
          expect(response).to render_template :create
        end
      end

      context 'double subscribe' do
        before { create(:subscription, user: @user, question: question) }

        it 'tries subscribe again' do
          expect { post :create, params: subscription_params }.to_not change(Subscription, :count)
        end
      end
    end

    context 'Non-authenticated user' do
      it 'tries to subscribe' do
        expect do
          post :create, params: subscription_params
        end.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:subscription) { create(:subscription, user: user) }
    let!(:subscription_params) { { id: subscription.id, format: :js } }

    context 'Authenticated user' do
      before { sign_in user }

      context 'author subscription' do
        it 'delete subscription' do
          expect { delete :destroy, params: subscription_params }.to change(Subscription, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, params: subscription_params
          expect(response).to render_template :destroy
        end
      end

      context 'not author subscription' do
        sign_in_user

        it 'delete subscription' do
          expect { delete :destroy, params: subscription_params }.to_not change(Subscription, :count)
        end

        it 'render error' do
          delete :destroy, params: subscription_params
          expect(response).to have_http_status :forbidden
        end
      end
    end

    context 'Non-authenticated user' do
      it 'delete subscription' do
        expect { delete :destroy, params: subscription_params }.to_not change(Subscription, :count)
      end
    end
  end
end
