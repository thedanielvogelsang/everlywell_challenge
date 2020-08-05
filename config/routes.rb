Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :searches, only: [:create]
      resources :users, only: [:index, :show, :create]
    end
  end
end
