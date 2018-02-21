Rails.application.routes.draw do
  # devise_for :users
  devise_for :user, controllers: {  
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  namespace :admin do
    resources :jobs do
    member do
    post :publish
    post :hide
    end
    resources :resumes
    end
    
    resources :locations do
      member do
        post :publish
        post :hide
        post :up
        post :down
      end
    end

    resources :categories do
      member do
        post :publish
        post :hide
        post :up
        post :down
      end
    end
  end

  resources :jobs do
    resources :resumes
      member do
        post :add
        post :remove
      end
      collection do
        get :search
      end
  end
  
  namespace :account do
    resources :collections
    resources :resumes
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
end
