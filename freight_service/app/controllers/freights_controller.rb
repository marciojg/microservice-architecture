# frozen_string_literal: true

class FreightsController < ApplicationController
  def calculate
    @freight = Freight.new(calculate_params)

    if @freight.valid?
      render json: { freight_value: @freight.calculate }
    else
      render json: @freight.errors, status: :unprocessable_entity
    end
  end

  private

  def calculate_params
    params.require(:calculate).permit(:client_id, :total_price, :total_items, :zip_code)
  end
end
