Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#index'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  patch 'users/confirmation_email', to: 'users#confirmation_email', as: 'user_confirmation_email'

  concern :votable do
    resources :votes, only: [:create, :destroy]
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      member do
        patch :mark_best
      end
    end
  end

  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :index
      end
    end
  end

  mount ActionCable.server => '/cable'
end
