Rails.application.routes.draw do
  devise_for :users
  resources :pictures
  resources :categories do
    get :available_pictures, on: :member
  end

  get 'users/profile', as: 'user_root'
  root to: 'home#index'
end



