Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  resources :webhooks

  post '/save', to: 'home#save'
  post '/update', to: 'home#update'
end
