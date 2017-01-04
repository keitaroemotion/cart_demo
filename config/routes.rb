Rails.application.routes.draw do
  resources :carts
  get  'endpoint/index'
  root 'endpoint#index'
end
