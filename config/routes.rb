Rails.application.routes.draw do
  devise_for :users
  root 'homes#index'

  get 'products/raw' => 'products#raw'
  get 'products/:id/edit' => 'products#edit', as: :count_edit

  post 'products/:id/update' => 'products#update', as: :count_update

  resources :products
  resources :homes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
