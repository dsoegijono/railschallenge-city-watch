class RespondersController < ApplicationController
  before_action :find_responder, only: [:show, :update]

  def create
    r = params['responder']
    errors = {}

    unpermitted = %w(id on_duty emergency_code)
    return if check_unpermitted_param(unpermitted, params['responder'])

    errors[:name] = ['can\'t be blank'] unless r['name']
    errors[:type] = ['can\'t be blank'] unless r['type']
    errors[:capacity] = ['can\'t be blank'] unless r['capacity']

    if r['capacity'].to_i < 1 || r['capacity'].to_i > 5
      errors[:capacity] = [] if errors[:capacity].nil?
      errors[:capacity] << 'is not included in the list'
    end

    if Responder.where(name: r['name']).count > 0
      errors[:name] = [] if errors[:name].nil?
      errors[:name] << 'has already been taken'
    end

    if errors.blank?
      @responder = Responder.create!(responder_params)
      render json: { responder: @responder }, status: 201
    else
      render json: { message: errors }, status: 422
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

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity, :emergency_code, :on_duty)
  end
end
