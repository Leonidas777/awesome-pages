AwesomePages::Application.routes.draw do

  root to: 'pages#index'

  get '/add',     to: 'pages#new',     as: :add_root_page
  get '*id/add',  to: 'pages#new',     as: :add_new_page
  get '*id/edit', to: 'pages#edit',    as: :edit_page
  get '*id',      to: 'pages#show',    as: :show_page

  post '/pages',  to: 'pages#create',  as: :create_page
  put '*id',      to: 'pages#update',  as: :update_page
  delete '*id',   to: 'pages#destroy', as: :delete_page
end
