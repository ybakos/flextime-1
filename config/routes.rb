Rails.application.routes.draw do

  root to: 'static_pages#home'

  # https://github.com/zquestz/omniauth-google-oauth2
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  resources :activities do
    post 'copy', on: :collection
    get 'attendance', on: :collection
  end
  resources :teachers, except: [:new] do
    put 'deactivate', on: :member
    put 'activate', on: :member
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

  namespace :sys_admin do
    resources :schools
  end

end
