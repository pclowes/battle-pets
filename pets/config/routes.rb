Rails.application.routes.draw do
  resources :pets, only: [:create], via: :options
  post "/pets/contest_result", to: "pets#contest_result", via: :options
end
