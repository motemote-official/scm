Rails.application.routes.draw do
  devise_for :users
  root 'homes#index'

  get 'products/raw' => 'products#raw'
  get 'products/all' => 'products#all'
  get 'products/list' => 'products#list'
  get 'tag/:id/destroy' => 'tags#destroy', as: :tag_destroy

  post 'regrams/tag' => 'regrams#tag'
  post 'rocket_regrams/tag' => 'rocket_regrams#tag'

  resources :homes
  resources :products, shallow: true do
    member do
      get 'empty'
    end
  end
  resources :members
  resources :regrams
  resources :tags
  resources :counts
  resources :rockets, shallow: true do
    resources :mission_checks do
      collection do
        post 'change'
      end
    end
    resources :missions
    resources :rocket_regrams do
      collection do
        get 'list'
      end
    end
    member do
      get 'calendar'
      get 'attend'
      get 'attend_show'
      get 'absent'
      get 'mission'
      post 'check'
      post 'upload_csv'
    end
  end
  resources :rocket_members
  resources :rocket_apply do
    member do
      get 'excel'
      post 'pass'
    end
  end
  resources :facebooks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
