# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tickets, only: [] do
    collection do
      get :open, to: 'tickets#opened'
      get :closed, to: 'tickets#closed'
      post :open, to: 'tickets#open'
      post :closed, to: 'tickets#close'
    end
  end
end
