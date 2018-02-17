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
  end
  resources :jobs do
    resources :resumes 
  end     
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
end
