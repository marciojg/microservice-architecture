class WishlistsController < ApplicationController
  before_action :set_wishlist, only: [:show, :update, :destroy, :item_index, :item_create]

  # GET /wishlists
  def index
    @wishlists = Wishlist.all

    render json: @wishlists
  end

  # GET /wishlists/1
  def show
    render json: @wishlist
  end

  # POST /wishlists
  def create
    @wishlist = Wishlist.new(wishlist_params)

    if @wishlist.save
      render json: @wishlist, status: :created, location: @wishlist
    else
      render json: @wishlist.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /wishlists/1
  def update
    if @wishlist.update(wishlist_params)
      render json: @wishlist
    else
      render json: @wishlist.errors, status: :unprocessable_entity
    end
  end

  # DELETE /wishlists/1
  def destroy
    @wishlist.destroy
  end

  def item_index
    @items = @wishlist.items.ransack(params[:q]).result

    render json: @items
  end

  def item_create
    @item = Item.new(item_params)
    @item.wishlist = @wishlist

    if @item.save
      render json: @wishlist.items, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  private

  def set_wishlist
    @wishlist = Wishlist.find(params[:id])
  end

  def wishlist_params
    params.require(:wishlist).permit(:client_id)
  end

  def item_params
    params.require(:item).permit(:product_id)
  end
end
