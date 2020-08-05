Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :searches, only: [:create]
      resources :users, only: [:index, :show, :create]
    end
  end

  post 'find_expert', to: 'api/v1/searches#find_expert' # find_expert_path
end
