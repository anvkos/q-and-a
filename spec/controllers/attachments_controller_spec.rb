require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    let!(:attachment) { create(:attachment, attachable: question) }

    context 'Authenticated user' do
      context 'User is author' do
        before { sign_in attachment.attachable.user }

        it 'try delete attachmend file' do
          expect { delete :destroy, params: { id: attachment }, format: :js }.to change(Attachment, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: attachment }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'User is not the author' do
        sign_in_user

        it 'try delete attachmend file' do
          expect { delete :destroy, params: { id: attachment }, format: :js }.to_not change(Attachment, :count)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: attachment }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Non-authenticated user' do
      it 'delete attachment' do
        expect { delete :destroy, params: { id: attachment }, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end
