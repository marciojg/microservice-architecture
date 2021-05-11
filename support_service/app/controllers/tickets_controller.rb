# frozen_string_literal: true

class TicketsController < ApplicationController

  # GET /tickets/open
  def opened
    @tickets = Ticket.open.ransack(params[:q]).result

    render json: @tickets
  end

  # GET /tickets/closed
  def closed
    @tickets = Ticket.closed.ransack(params[:q]).result

    render json: @tickets
  end

  # POST /tickets/open
  def open
    @ticket = Ticket.new(open_ticket_params)

    if @ticket.save
      render json: Ticket.open, status: :created
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  # POST /tickets/closed
  def close
    @ticket = Ticket.find(close_ticket_params)
    @ticket.status = 1

    if @ticket.save
      render json: Ticket.closed, status: :created
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  private

  def open_ticket_params
    params.require(:ticket).permit(:description, :client_id)
  end

  def close_ticket_params
    params.require(:ticket).permit(:id)
  end
end
