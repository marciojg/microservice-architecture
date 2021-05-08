Rails.application.routes.draw do
  resources :products
  resources :categories do
    get :products, on: :member
  end
end
