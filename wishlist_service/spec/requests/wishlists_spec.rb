require 'swagger_helper'

RSpec.describe 'wishlists', type: :request do

  path '/wishlists/{id}/items' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('item_index wishlist') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('item_create wishlist') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/wishlists' do

    get('list wishlists') do
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create wishlist') do
      tags 'Wishlists'
      consumes 'application/json'
      parameter name: :layout, in: :body,required: true,
      schema: {
        type: :object,
        properties: {
          wishlist: {
            type: :object,
            properties: {
              client_id: {
                "description": "Id do cliente associado",
                "type": "integer",
                "example": 100
               }
            }
          }
        },
        required: [ 'client_id' ]
      }

      response '201', 'wishlist created' do
        let(:wishlist) do
          {
            "id": 2,
            "client_id": 100,
            "created_at": "2021-05-12T22:00:03.915Z",
            "updated_at": "2021-05-12T22:00:03.915Z"
          }
        end

        run_test!
      end

      response '422', 'invalid request' do
        let(:wishlist) { { client_id: 'xxx' } }
        run_test!
      end

      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/wishlists/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show wishlist') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('update wishlist') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update wishlist') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete wishlist') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
