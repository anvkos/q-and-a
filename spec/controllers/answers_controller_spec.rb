require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'answer belongs to the user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(Answer.last.user).to eq @user
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        end.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { sign_in answer.user }

      context 'with valid attributes' do
        it 'assings the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          updated_body = 'new updated body'
          patch :update, params: { id: answer, answer: { body: updated_body }, format: :js }
          answer.reload
          expect(answer.body).to eq updated_body
        end

        it 'render update template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:invalid_body) { 'short' }
        before do
          patch :update, params: { id: answer, answer: { body: invalid_body }, format: :js }
        end

        it 'does not update the answer' do
          answer.reload
          expect(answer.body).to_not eq invalid_body
        end

        it 'render update template' do
          expect(response).to render_template :update
        end
      end

      context 'User is not author' do
        let!(:another_user) { create(:user) }
        let!(:another_answer) { create(:answer, user: another_user, question: question) }

        it 'try update answer' do
          updated_body = 'text updated others'
          patch :update, params: { id: another_answer, answer: { body: updated_body }, format: :js }
          expect(another_answer.body).to_not eq updated_body
        end
      end
    end

    context 'Non-authenticated user' do
      it 'update answer' do
        updated_body = 'updated body'
        patch :update, params: { id: answer, answer: { body: updated_body }, format: :js }
        answer.reload
        expect(answer.body).to_not eq updated_body
      end
    end
  end

  describe 'PATCH #mark_best' do
    context 'Authenticated user' do
      before { sign_in question.user }

      context 'asker' do
        before { patch :mark_best, params: { id: answer }, format: :js }
        it 'marks best answer' do
          expect(answer.reload).to be_best
        end

        it 'render template best' do
          expect(response).to render_template :mark_best
        end
      end

      context 'not asker' do
        sign_in_user

        it 'marks best answer' do
          patch :mark_best, params: { id: answer }, format: :js
          expect(answer.reload).to_not be_best
        end
      end
    end

    context 'Non-authenticated user' do
      it 'marks best answer' do
        patch :mark_best, params: { id: answer }, format: :js
        expect(answer.reload).to_not be_best
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { sign_in answer.user }

      context 'User is author' do
        it 'delete answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'User is not the author' do
        let!(:another_user) { create(:user) }
        let!(:another_answer) { create(:answer, user: another_user, question: question) }
        render_views

        it 'try delete answer' do
          another_answer
          expect { delete :destroy, params: { id: another_answer }, format: :js }.to_not change(Answer, :count)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: another_answer }, format: :js
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end

    context 'Non-authenticated user' do
      it 'delete answer' do
        answer
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end
end
