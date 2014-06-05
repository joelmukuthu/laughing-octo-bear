Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, 
             controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  # request email from users signed in with twitter
  match '/users/:id/add_email' => 'users#add_email', 
        via: [:get, :patch, :post], 
        as: :add_user_email

  resources :missions
  match '/missions/:id/flag' => 'missions#flag', via: [:patch, :put], as: :flag_mission

  resources :messages
  
  resources :categories
end
