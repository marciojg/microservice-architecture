# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :set_open_ticket, only: [:close]

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
    if @ticket.blank?
      return render json: { message: 'Ticket not found' }, status: :unprocessable_entity
    end

    if @ticket.close
      render json: Ticket.closed, status: :created
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  private

  def set_open_ticket
    @ticket = Ticket.find_by(close_ticket_params.to_h.merge(status: :open))
  end

  def open_ticket_params
    params.require(:ticket).permit(:description, :client_id)
  end

  def close_ticket_params
    params.require(:ticket).permit(:id)
  end
end
