Rails.application.routes.draw do
  devise_for :users
  resources :pictures
  resources :categories

  get 'users/profile', as: 'user_root'
  root to: 'home#index'
end



