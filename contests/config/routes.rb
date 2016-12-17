Rails.application.routes.draw do
  resources :contests, only: [:create], via: :options
end
