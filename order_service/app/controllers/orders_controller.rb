# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_open_order, only: [:close]

  # GET /orders/{id}
  def show
    @order = Order.find(params[:id])

    render json: @order
  end

  # GET /orders/open
  def opened
    @orders = Order.open.ransack(params[:q]).result

    render json: @orders
  end

  # GET /orders/closed
  def closed
    @orders = Order.closed.ransack(params[:q]).result

    render json: @orders
  end

  # POST /orders/open
  def open
    @order = Order.new(open_order_params)

    if @order.save
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # POST /orders/closed
  def close
    if @order.blank?
      return render json: { message: 'Order not found' }, status: :unprocessable_entity
    end

    if @order.close
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # POST /orders/{id}/freight
  def freight
    zip_code = freight_params[:zip_code]

    if zip_code.present?
      order = Order.find(params[:id])

      obj = {
        total_price: order.total_price,
        total_items: order.total_items,
        zip_code: zip_code
      }

      DeliveryBoy.deliver(obj, key: order.cart_client_id, topic: 'CALCULATE_FREIGHT_CHANNEL')

      render status: :ok
    else
      render json: { message: 'zip code error' }, status: :unprocessable_entity
    end
  end

  private

  def set_open_order
    @order = Order.find_by(close_order_params.to_h.merge(status: :open))
  end

  def open_order_params
    params.require(:order).permit(:cart_client_id)
  end

  def close_order_params
    params.require(:order).permit(:id)
  end

  def freight_params
    params.require(:freight).permit(:zip_code)
  end
end
