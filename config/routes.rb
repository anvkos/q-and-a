Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#index'
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :mark_best
      end
    end
  end

  resources :attachments, only: [:destroy]
end
