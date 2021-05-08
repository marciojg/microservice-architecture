# frozen_string_literal: true

Rails.application.routes.draw do

  resources :wishlists do
    get :items, on: :member, to: 'wishlists#item_index'
    post :items, on: :member, to: 'wishlists#item_create'
  end
end
