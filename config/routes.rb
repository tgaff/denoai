Rails.application.routes.draw do
  resources :data_imports
  get 'messages/create'
  resources :chats do
    resources :messages, only: [:create]
  end
  resources :data_imports, only: [:create, :index, :new, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  mount GoodJob::Engine => 'good_job'
  root "chats#index"
end
