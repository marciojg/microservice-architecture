# frozen_string_literal: true

Rails.application.routes.draw do
  resources :orders, only: [:show] do
    collection do
      get :open, to: 'orders#opened'
      get :closed, to: 'orders#closed'
      post :open, to: 'orders#open'
      post :closed, to: 'orders#close'
    end
  end
end
