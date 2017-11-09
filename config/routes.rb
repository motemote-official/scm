Rails.application.routes.draw do
  devise_for :users
  root 'homes#index'

  get 'products/raw' => 'products#raw'
  get 'products/all' => 'products#all'
  get 'products/list' => 'products#list'
  get 'tag/:id/destroy' => 'tags#destroy', as: :tag_destroy
  get 'attend/index'

  post 'regrams/tag' => 'regrams#tag'
  post 'attend/check'

  resources :homes
  resources :products
  resources :members
  resources :regrams
  resources :tags
  resources :counts
  resources :rockets
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
