Rails.application.routes.draw do
  resources :impositions, only: [:new, :create], path: ""
  resources :messages, only: [:create]

  root to: "impositions#new"
end
