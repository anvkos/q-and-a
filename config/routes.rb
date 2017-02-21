Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#index'
  devise_for :users

  concern :votable do
    resources :votes, only: [:create, :destroy]
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true do
      member do
        patch :mark_best
      end
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
