Rails.application.routes.draw do
  devise_for :users
  root 'homes#index'

  get 'products/raw' => 'products#raw'
  get 'products/all' => 'products#all'
  get 'products/list' => 'products#list'
  get 'tag/:id/destroy' => 'tags#destroy', as: :tag_destroy

  post 'regrams/tag' => 'regrams#tag'

  resources :homes
  resources :products
  resources :members
  resources :regrams
  resources :tags
  resources :counts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
