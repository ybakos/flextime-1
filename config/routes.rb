Rails.application.routes.draw do

  root to: 'students#show', constraints: lambda { |req| req.env['warden'].user&.student? }
  root to: 'activities#index'

  # https://github.com/zquestz/omniauth-google-oauth2
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :activities do
    post 'copy', on: :collection
    get 'attendance', on: :collection
  end
  resources :teachers, except: [:new] do
    put 'deactivate', on: :member
  end
  resources :students, only: [:index, :show, :update, :edit] do
    patch 'reset_teachers', on: :collection
    resources :registrations, only: [:create, :edit, :update, :destroy] do
      patch 'mark_attendance', on: :member
    end
  end

  scope '/admin' do
    resources :users, only: [:index, :update]
  end

end
