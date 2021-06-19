# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_dry_run = false

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:1004'
            }
          }
        }
      ],
      components: {
        schemas: {
          errors_object: {
            type: 'object',
            properties: {
              errors: { '$ref' => '#/components/schemas/errors_map' }
            }
          },
          errors_map: {
            type: 'object',
            additionalProperties: {
              type: 'array',
              items: { type: 'string' }
            }
          },
          open_order: {
            post: {
              request: {
                type: 'object',
                properties: {
                  order: {
                    type: 'object',
                    properties: {
                      cart_client_id: { type: 'integer', example: 1 }
                    },
                  },
                  required: %w[cart_client_id]
                }
              },
              response: {
                type: 'object',
                properties: {
                  id: { type: 'integer', example: 0 },
                  attributes: {
                    type: 'object',
                    properties: {
                      status:         { type: 'string', example: 'open' },
                      cart_client_id: { type: 'integer', example: 100 },
                      freight_value:  { type: 'number', format: 'float', nullable: true },
                      total_price:    { type: 'number', format: 'float', nullable: true },
                      total_items:    { type: 'integer', nullable: true },
                      created_at:     { type: 'string', format: 'date-time' },
                      updated_at:     { type: 'string', format: 'date-time' },
                    }
                  }
                },
                required: %w[id status cart_client_id freight_value total_price total_items created_at updated_at]
              }
            },
            get: {
              type: 'array',
              items: { '$ref' => '#/components/schemas/open_order/post/response' }
            }
          },
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json
end
