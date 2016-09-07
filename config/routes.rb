Rails.application.routes.draw do
  devise_for :users

  get 'users/change_password'
  put 'users/save_password' => 'users#save_password'

  resources :pictures do
    get 'refresh', on: :collection
  end
  resources :looks do
     get 'available_pictures', on: :member
     post 'add_pictures', on: :member
  end
  resources :categories do
    get 'available_pictures', on: :member
    post 'add_pictures', on: :member
  end

  get 'users/profile', as: 'user_root'
  root to: 'home#index'
end



