Rails.application.routes.draw do

  root to: 'BROKEN'

  # https://github.com/zquestz/omniauth-google-oauth2
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

end
