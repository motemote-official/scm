Rails.application.routes.draw do
  devise_for :users
  root 'homes#index'

  get 'products/raw' => 'products#raw'
  get 'products/:id/edit' => 'products#edit', as: :count_edit
  get 'tag/:id/destroy' => 'tags#destroy', as: :tag_destroy

  post 'products/:id/update' => 'products#update', as: :count_update

  resources :homes
  resources :products
  resources :members
  resources :regrams
  resources :tags
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
