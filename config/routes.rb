Rails.application.routes.draw do
  resources :pictures
  root to: redirect('/about.html')
end



