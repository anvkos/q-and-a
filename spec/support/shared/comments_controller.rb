shared_examples_for 'Create Comment' do
  let(:commentable_params) do
    params = {}
    params.store("#{commentable.class.name.underscore}_id", commentable.id)
    params
  end
  let!(:comment_params) { commentable_params.merge(comment: attributes_for(:comment), format: :json) }

  context 'Authenticated user' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new comment in the database' do
        expect do
          post :create, params: comment_params
        end.to change(commentable.comments, :count).by(1)
      end

      it 'comment belongs to the user' do
        post :create, params: comment_params
        expect(Comment.last.user).to eq @user
      end

      it 'render success json' do
        post :create, params: comment_params
        comment = commentable.comments.last
        data = JSON.parse(response.body)

        expect(response).to have_http_status :success
        expect(data['id']).to eq assigns(:comment).id
        expect(data['content']).to eq comment.content
        expect(data['commentable_type']).to eq commentable.class.name.underscore
        expect(data['commentable_id']).to eq commentable.id
        expect(data['message']).to eq 'Your comment has been added!'
      end
    end

    context 'with invalid attributes' do
      let!(:invalid_comment_params) { commentable_params.merge(comment: { content: 'text' }, format: :json) }

      it 'does not save the comment' do
        expect do
          post :create, params: invalid_comment_params
        end.to_not change(Comment, :count)
      end

      it 'render error json' do
        post :create, params: invalid_comment_params
        data = JSON.parse(response.body)
        expect(response).to have_http_status :unprocessable_entity
        expect(data['error']).to eq 'Error save'
        expect(data['error_message']).to eq 'Not the correct comment data!'
      end
    end
  end

  context 'Non-authenticated user' do
    it 'tries to comment' do
      expect do
        post :create, params: comment_params
      end.to_not change(Comment, :count)
    end
  end
end
