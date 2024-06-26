Rails.application.routes.draw do
  resources :json_exports, only: [:index, :show], param: :library_id do
    member do 
      get 'download'
    end
  end
  resources :data_imports
  get 'messages/create'
  resources :chats do
    resources :messages, only: [:create]
  end
  resources :lz_chats do
    resources :messages, only: [:create]
  end

  resources :data_imports, only: [:create, :index, :new, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  mount GoodJob::Engine => 'good_job'
  root "lz_chats#new"
end
