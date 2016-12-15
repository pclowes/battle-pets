Rails.application.routes.draw do
  resources :pets, only: [:create], via: :options
end
