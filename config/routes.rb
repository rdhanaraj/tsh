Tsh::Application.routes.draw do
  devise_for :users

  root 'pages#index'
  get '/settings' => 'pages#index'
  get '/docs' => 'pages#docs'
  get '/facebook' => 'facebook#index'
  get '/facebook/callback' => 'facebook#callback'
  get '/gmail' => 'gmail#index'
  get '/gmail/callback' => 'gmail#callback'

  resource :sms, only: :create
end
