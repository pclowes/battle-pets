Rails.application.routes.draw do
  resources :contests, only: [:create], via: :options
  resources :statuses, only: [:index], via: :options
end
