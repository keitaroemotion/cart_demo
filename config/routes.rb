Rails.application.routes.draw do
  get  'endpoint/index'
  root 'endpoint#index'
end
