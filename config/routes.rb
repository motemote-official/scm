Rails.application.routes.draw do
  root 'homes#index'

  get 'products/raw' => 'products#raw'

  resources :products
  resources :homes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
