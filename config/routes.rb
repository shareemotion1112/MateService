Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    # Add custom Devise routes here
    get "sign_in", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new"
    get "forgot_password", to: "devise/passwords#new"
    get "reset_password", to: "devise/passwords#edit"
    delete "sign_out", to: "devise/sessions#destroy"
  end

  # API routes
  namespace :api do
    namespace :v1 do
      resources :projects do
        resources :team_members, only: [ :index, :create, :update, :destroy ]
      end
      resources :skills, only: [ :index, :show, :create ]
      resources :messages, only: [ :index, :create, :update ]
      resources :groups do
        member do
          post :join
          delete :leave
        end
        resources :messages, only: [ :index, :create ]
      end
      resources :users, only: [ :index, :show, :update ] do
        collection do
          get :search
        end
      end
    end
  end

  # Web routes
  resources :users, only: [ :index, :show ]
  resources :skills, only: [ :create ]
  resources :roles, only: [ :create ]
  resources :projects do
    resources :team_members, only: [ :create, :destroy, :index, :new, :edit, :update ]
    member do
      post :join
      delete :leave
    end
  end
  resources :groups do
    member do
      post :join
      delete :leave
    end
    resources :messages, only: [ :index, :create ]
  end
  resources :messages, only: [ :index, :create, :show, :new ]

  # ActionCable
  mount ActionCable.server => "/cable"

  # 루트 페이지
  root "pages#home"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
