Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # get 'home/index'
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # delete 'users/sign_out' => 'users/sessions#destroy', :as => :destroy_user_session

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }

  post 'home/update_user_log', to: 'home#update_user_log', as: 'update_user_log_home'
  post 'create_leave_request', to: 'home#create_leave_request'


  post 'home/update_user_break', to: 'home#update_user_break', as: 'update_user_break_home'


  resources :user_logs do
    collection do
      get 'user_logs_mnth'
      get :daily_log_user
    end
    member do
      # post 'update_user_log'
    end
  end

  # config/routes.rb
post '/update_user_log', to: 'user_logs#update_user_log', as: 'update_user_log'





  devise_scope :user do
    get 'user_sign_out', to: 'users/registrations#user_sign_out'
  end
  
  root to: 'home#index'

  # get 'dashboard', to: 'dashboard#index', as: 'dashboard'

  get 'otp/new', to: 'otp#new', as: 'new_user_otp'
  post 'otp', to: 'otp#create', as: 'user_otp'
  get 'otp/reset_password', to: 'otp#reset_password', as: 'reset_password_otp'
  post 'otp/reset_verify', to: 'otp#reset_verify', as: 'reset_verify_otp'


  resources :employees do
    post 'save_session_data', on: :collection, to: 'employees#save_session_data'
  end

  resources :dashboard, only: [:index] do
    collection do
      get 'download_user_logs', to: 'dashboard#download_user_logs'
    end
  end

  resources :tasks do
    member do
      patch 'assign'
      patch 'move'
      get 'delete_project', to: 'tasks#delete_project'
      
      get :task_delete
      patch :update_status
      post 'update_task_log_status'
    end
    collection do
      post 'upload_file'
      get 'get_team_members'
      get 'download_csv', defaults: { format: :csv }
    end
  end

  resources :home do
    collection do
      get 'category_based_list'
      get 'admin_leave_requests'
    end
    member do
      
    end
  end

  resources :users do
    member do
      post :approve
      patch :reject
    end
    collection do 
      # get 'accepted_users'
    end
  end

  resources :leave_requests do
    member do
      get 'accept'
      get :reject
    end
  end

  resources :leads do
    member do
      get 'lead_delete'
    end
    collection do
      post 'upload_file'
    end
  end

  resources :payslips do 
    collection do
      get 'download_payslips', defaults: { format: :csv }
    end
  end





  resources :payment_details do
    collection do
      get 'details', to: 'payslip_details#details', as: :payslip_details
    end
    member do
      delete :delete_details_img
      get :delete_pd
      post :given_update
    end
  end


 

  resource :passwrds, only: [:new, :create]
  get 'passwrds/verify', to: 'passwrds#verify', as: 'verify_passwrd'
  get 'passwrds/enter_otp', to: 'passwrds#enter_otp', as: 'enter_otp'
  get 'passwrds/new_password', to: 'passwrds#new_password', as: 'new_otp_password'
  post 'passwrds/update_password', to: 'passwrds#update_password', as: 'update_password'

  # post '/update_user_log', to: 'user_logs#update_user_log', as: 'update_user_log'



  
end
