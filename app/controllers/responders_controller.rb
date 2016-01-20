class RespondersController < ApplicationController
  def create
    r = params['responder']
    errors = {}

    unpermitted = %w(id on_duty emergency_code)
    return if check_unpermitted_param(unpermitted)

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
      render json: {
        message: errors
      }, status: 422
    end
  end

  def index
    @responders = Responder.all
    render json: {
      responders: @responders
    }, status: 200
  end

  def show
    @responder = Responder.where(name: params['id']).first
    if @responder
      render json: { responder: @responder }, status: 200
    else
      render nothing: true, status: 404
    end
  end

  def update
    unpermitted = %w(name type capacity emergency_code)
    return if check_unpermitted_param(unpermitted)

    @responder = Responder.where(name: params['id']).first
    if @responder
      if @responder.update(responder_params)
        render json: { responder: @responder }
      else
        render json: {
        }
      end
    else
      render nothing: true, status: 404
    end
  end

  private

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity, :emergency_code, :on_duty)
  end

  def check_unpermitted_param(unpermitted)
    unpermitted.each do |u|
      if params['responder'][u]
        render_error_unpermitted_param(u)
        return true
      end
    end
    false
  end

  def render_error_unpermitted_param(param)
    render json: { message: "found unpermitted parameter: #{param}" }, status: 422
  end
end
