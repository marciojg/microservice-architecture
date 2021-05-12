# frozen_string_literal: true

Rails.application.routes.draw do
  resources :freights, only: [] do
    collection do
      post :calculate, to: 'freights#calculate'
    end
  end
end
