require 'swagger_helper'

RSpec.describe 'orders', type: :request do

  before do
    allow(Rails.cache).to receive(:read)
    .with(CartsConsumer::CACHE_NAME)
    .and_return([ { 'client_id' => '122' }, { 'client_id' => '123' } ])
  end

  path '/orders/open' do
    post 'Cria um pedido' do
      tags 'Orders'
      description 'Cria um pedido e seus detalhes'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body,
                schema: { oneOf: [ { '$ref' => '#/components/schemas/open_order/post/request' } ] }

      response 200, 'Order created' do
        schema oneOf: [{ '$ref' => '#/components/schemas/open_order/post/response' }]

        let(:params) { { order: { cart_client_id: 123 } } }
        run_test!
      end

      response 422, 'Retorna uma lista de erros ao tentar adicionar um pedido' do
        schema oneOf: [{ '$ref' => '#/components/schemas/errors_object' }]

        let(:params) { { order: { cart_client_id: nil } } }

        run_test! do |response|
          expect(response.body).to include('is not a number')
        end
      end
    end

    get 'Lista de pedidos em aberto' do
      tags 'Orders'
      description 'Lista os pedidos em aberto, com diversas possibilidades de filtros usando o ransack (https://github.com/activerecord-hackery/ransack)'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :q, in: :query, type: :object

      let(:q) { { cart_client_id_eq: 123 }.to_param }

      response 200, 'Retorna uma lista de pedidos em aberto' do
        schema oneOf: [{ '$ref' => '#/components/schemas/open_order/get' }]

        let(:params) { { order: { cart_client_id: 123 } } }
        run_test!
      end
    end
  end

  # path '/orders/closed' do

  #   get('closed order') do
  #     tags 'Orders'
  #     produces 'application/json'
  #     response(200, 'successful') do

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   post('close order') do
  #     tags 'Orders'
  #     consumes 'application/json'
  #     response(200, 'successful') do

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end

  # path '/orders/{id}/freight' do
  #   # You'll want to customize the parameter types...
  #   parameter name: 'id', in: :path, type: :string, description: 'id'

  #   post('freight order') do
  #     tags 'Orders'
  #     consumes 'application/json'
  #     response(200, 'successful') do
  #       let(:id) { '123' }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end

  # path '/orders/{id}' do
  #   # You'll want to customize the parameter types...
  #   parameter name: 'id', in: :path, type: :string, description: 'id'

  #   get('show order') do
  #     tags 'Orders'
  #     produces 'application/json'
  #     response(200, 'successful') do
  #       let(:id) { '123' }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end
end
