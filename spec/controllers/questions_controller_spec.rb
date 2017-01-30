require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it 'question belongs to the user' do
        post :create, params: { question: attributes_for(:question) }
        expect(Question.last.user).to eq @user
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:invalid_question) }
        end.to_not change(Question, :count)
      end

      it 're-rendes new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'updated title', body: 'updated body' } }
        question.reload
        expect(question.title).to eq 'updated title'
        expect(question.body).to eq 'updated body'
      end

      it 'redirects to the update question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      let(:expetced_data) { { title: "premier Title", body: 'premier Body' } }
      let(:question) { create(:question, title: expetced_data[:title], body: expetced_data[:body]) }

      before do
        patch :update, params: { id: question, question: { title: 'updated title', body: nil } }
      end

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq expetced_data[:title]
        expect(question.body).to eq expetced_data[:body]
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { sign_in question.user }

      context 'User is author' do
        it 'delete question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'redirect to index view' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'User is not the author' do
        let(:another_user) { create(:user) }
        let(:another_question) { create(:question, user: another_user) }
        render_views

        it 'delete try question' do
          another_question
          expect { delete :destroy, params: { id: another_question } }.to_not change(Question, :count)
        end

        it 're-renders question view' do
          delete :destroy, params: { id: another_question }
          expect(response).to render_template :show
          expect(response.body).to match another_question.body
          expect(response.body).to match another_question.title
        end
      end
    end

    context 'Non-authenticated user' do
      it 'delete question' do
        question = create(:question)
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
