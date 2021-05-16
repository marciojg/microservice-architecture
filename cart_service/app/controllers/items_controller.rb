class ItemsController < ApplicationController
  before_action :set_cart, except: [:create]
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /carts/:cart_client_id/items
  def index
    @items = @cart.items.ransack(params[:q]).result

    render json: @items
  end

  # GET /carts/:cart_client_id/items/1
  def show
    render json: @item
  end

  # POST /carts/:cart_client_id/items
  def create
    cart = Cart.find_or_create_by(client_id: params[:cart_client_id])

    @item = Item.new(item_params)
    @item.cart = cart

    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /carts/:cart_client_id/items/1
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /carts/:cart_client_id/items/1
  def destroy
    @item.destroy
  end

  private

  def set_cart
    @cart = Cart.find(params[:cart_client_id])
  end

  def set_item
    @item = @cart.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:product_id, :wishlist_item_id, :amount)
  end
end
