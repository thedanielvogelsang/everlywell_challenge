Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :searches, only: [:create]
      resources :users, only: [:index, :show, :create]
    end
  end
  resources :users, only: [:index, :show]
  get 'tiny_urls/show'
  get 'find_expert', to: 'api/v1/searches#find_expert' # find_expert_path
end
