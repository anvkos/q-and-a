require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assings a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to show question view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        end.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { sign_in answer.user }

      context 'User is author' do
        it 'delete answer' do
          expect { delete :destroy, params: { id: answer, question_id: answer.question_id } }.to change(Answer, :count).by(-1)
        end

        it 'redirect to question view' do
          delete :destroy, params: { id: answer, question_id: question }
          expect(response).to redirect_to question
        end
      end

      context 'User is not the author' do
        it 'try delete answer' do
          another_user = create(:user)
          another_answer = create(:answer, user: another_user, question: question)
          expect { delete :destroy, params: { id: another_answer, question_id: another_answer.question_id } }.to_not change(Answer, :count)
        end
      end
    end

    context 'Non-authenticated user' do
      it 'delete answer' do
         answer
         expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end
  end
end
