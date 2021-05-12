# frozen_string_literal: true

class FreightsController < ApplicationController
  def calculate
    @freight = Freight.new(calculate_params)

    if @freight.valid?
      render json: { freight_price: @freight.calculate }
    else
      render json: @freight.errors, status: :unprocessable_entity
    end
  end

  private

  def calculate_params
    params.require(:calculate).permit(:total_price, :total_items, :zip_code)
  end
end
