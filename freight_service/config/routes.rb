# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resources :freights, only: [] do
    collection do
      post :calculate, to: 'freights#calculate'
    end
  end
end
