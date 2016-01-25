class RespondersController < ApplicationController
  before_action :find_responder, only: [:show, :update]

  def create
    unpermitted = %w(id on_duty emergency_code)
    return if check_unpermitted_param(unpermitted, params['responder'])

    @responder = Responder.new(create_params)
    if @responder.save
      render json: { responder: @responder }, status: :created
    else
      render json: { message: @responder.errors.messages }, status: :unprocessable_entity
    end
  end

  def index
    @responders = Responder.all
    render json: { responders: @responders }, status: 200
  end

  def show
    if @responder
      render json: { responder: @responder }, status: 200
    else
      render nothing: true, status: 404
    end
  end

  def update
    unpermitted = %w(name type capacity emergency_code)
    return if check_unpermitted_param(unpermitted, params['responder'])

    if @responder
      if @responder.update(responder_params)
        render json: { responder: @responder }
      end
    else
      render nothing: true, status: 404
    end
  end

  private

  def find_responder
    @responder = Responder.where(name: params['id']).first
  end

  def create_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity, :emergency_code, :on_duty)
  end
end
