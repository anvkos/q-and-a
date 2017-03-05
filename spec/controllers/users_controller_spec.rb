require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'PATCH #confirmation_email' do
    context 'with valid attributes' do
      it 'assigns @user by token' do
        user = create(:unconfirmed_user)
        patch :confirmation_email, params: { user: { email: 'user@test.com' }, token: user.confirmation_token }
        expect(assigns(:user)).to eq user
      end

      it 'set unconfirmed email' do
        user = create(:unconfirmed_user)
        temporary_email = user.email
        confirmed_email = 'user@test.com'
        patch :confirmation_email, params: { user: { email: confirmed_email }, token: user.confirmation_token }
        user.reload
        expect(user.unconfirmed_email).to eq confirmed_email
        expect(user.email).to eq temporary_email
      end
    end

    context 'user try confirm email with invalid attributes' do
      it 'user not found by token' do
        email = 'test0@test.com'
        patch :confirmation_email, params: { user: { email: email } }
        expect(response).to have_http_status :not_found
      end

      context 'email alredy use' do
        it 'try use email another user' do
          another_user_email = create(:user).email
          user = create(:unconfirmed_user)
          patch :confirmation_email, params: { user: { email: another_user_email }, token: user.confirmation_token }
          expect(user.unconfirmed_email).to_not eq another_user_email
          expect(user.email).to_not eq another_user_email
        end

        it 're-renders confirmation email template' do
          another_user_email = create(:user).email
          user = create(:unconfirmed_user)
          patch :confirmation_email, params: { user: { email: another_user_email }, token: user.confirmation_token }
          expect(response).to render_template :confirmation_email
        end
      end

      context 'email empty' do
        it 'try use email blank' do
          user = create(:unconfirmed_user)
          patch :confirmation_email, params: { user: { email: '' }, token: user.confirmation_token }
          expect(response).to have_http_status :unprocessable_entity
          expect(user.unconfirmed_email).to be_nil
          expect(user.email).to_not eq be_empty
        end

        it 're-renders confirmation email template' do
          user = create(:unconfirmed_user)
          patch :confirmation_email, params: { user: { email: '' }, token: user.confirmation_token }
          expect(response).to render_template :confirmation_email
        end
      end
    end
  end
end
