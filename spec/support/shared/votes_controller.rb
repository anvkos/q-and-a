shared_examples_for 'Create Vote' do
  let(:votable_params) do
    params = {}
    params.store("#{votable.class.name.underscore}_id", votable.id)
    params
  end
  let!(:vote_params) { votable_params.merge(rating: 'up', format: :json) }

  context 'Authenticated user' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new vote in the database' do
        expect { post :create, params: vote_params }.to change(votable.votes, :count).by(1)
      end

      it 'render success' do
        post :create, params: vote_params
        votable.reload
        data = JSON.parse(response.body)
        expect(response).to have_http_status :success
        expect(data['id']).to eq assigns(:vote).id
        expect(data['votable_rating']).to eq votable.rating
        expect(data['votable_type']).to eq votable.class.name.underscore
        expect(data['votable_id']).to eq votable.id
        expect(data['action']).to eq 'create'
        expect(data['message']).to eq 'Your vote has been accepted!'
      end
    end

    context 'double voting' do
      before { create(:vote, votable: votable, user: @user) }

      it 'tries vote again' do
        expect { post :create, params: vote_params }.to_not change(votable.votes, :count)
      end
    end

    context 'with invalid attributes' do
      let(:rating_missing) { votable_params.merge(format: :json) }
      let(:invalid_rating) { votable_params.merge(rating: 'something', format: :json) }

      context 'save vote with a negative evaluation' do
        it 'rating missing' do
          expect { post :create, params: rating_missing }.to change(votable.votes, :count).by(1)
          expect(votable.rating).to eq(-1)
        end

        it 'invalid rating' do
          expect { post :create, params: invalid_rating }.to change(votable.votes, :count).by(1)
          expect(votable.rating).to eq(-1)
        end
      end
    end

    context 'User is author votable' do
      before { sign_in votable.user }

      it 'vote not stored in the database' do
        expect { post :create, params: vote_params }.to_not change(Vote, :count)
      end

      it 'render error' do
        post :create, params: vote_params
        data = JSON.parse(response.body)
        expect(response).to have_http_status :forbidden
        expect(data['error']).to eq 'forbidden'
        expect(data['error_message']).to eq 'You are not authorized to access this page.'
      end
    end
  end

  context 'Non-authenticated user' do
    it 'tries vote' do
      expect do
        post :create, params: vote_params
      end.to_not change(Vote, :count)
    end
  end
end
