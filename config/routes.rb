Rails.application.routes.draw do
  resources :products do
    collection do
      get :search
    end
  end

  post 'products/upload', to: 'products#upload_file'

  root 'products#index'
end