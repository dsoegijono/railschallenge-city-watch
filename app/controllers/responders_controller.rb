class RespondersController < ApplicationController
  def create
    @responder = Responder.new(responder_params)

    errors = {}

    if @responder[:capacity] < 1 || @responder.capacity > 5
      errors[:capacity] = [] if errors[:capacity].nil?
      errors[:capacity] << 'is not included in the list'
    end

    if Responder.where(name: @responder.name).count > 0
      errors[:name] = [] if errors[:name].nil?
      errors[:name] << 'has already been taken'
    end

    unless @responder.emergency_code.nil?
      errors == 'found unpermitted parameter: emergency_code'
    end

    # cannot set id

    # cannot set on_duty

    if @responder.name.nil?
      errors[:name] = [] if errors[:name].nil?
      errors[:name] << 'can\'t be blank'
    end

    if errors == {} || (errors.is_a?(String) && !errors.nil?)
      @responder = Responder.create!(responder_params)
      render json: { responder: @responder }, status: 201
    else
      render json: {
        message: errors
      }, status: 422
    end
  end

  private

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end
end
