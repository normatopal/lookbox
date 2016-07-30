Rails.application.routes.draw do
  devise_for :users
  resources :pictures
  resources :categories do
    collection do
      get :manage
      # required for Sortable GUI server side actions
      post :rebuild
    end
  end

  get 'users/profile', as: 'user_root'
  root to: 'home#index'
end



