Rails.application.routes.draw do
  devise_for :users

  get 'users/change_password'
  put 'users/save_password' => 'users#save_password'

  resources :pictures
  resources :categories

  get 'users/profile', as: 'user_root'
  root to: 'home#index'
end



