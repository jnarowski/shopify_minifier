Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  resources :webhooks

  post '/save_all', to: 'home#save_all'
  post '/update', to: 'home#update'
  delete '/destroy/:id', to: 'home#destroy'

  get '/minify_javascripts', to: 'home#minify_javascripts'
  get '/minify_stylesheets', to: 'home#minify_stylesheets'
end
