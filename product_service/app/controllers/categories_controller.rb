# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy, :products]

  # GET /categories
  def index
    @categories = Category.ransack(params[:q]).result

    render json: @categories
  end

  # GET /categories/1
  def show
    render json: @category
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
  end

  def products
    @search = @category.products.ransack(params[:q])
                      
    @search.sorts = 'total_access desc' if params[:popular] == 'true'
    @products = @search.result

    render json: @products
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_params
    params.require(:category).permit(:name)
  end
end
