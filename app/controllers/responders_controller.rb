class RespondersController < ApplicationController
  def create
    r = params['responder']
    errors = {}

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

    if errors.blank? && r['emergency_code']
      errors = 'found unpermitted parameter: emergency_code'
    elsif errors.blank? && r['id']
      errors = 'found unpermitted parameter: id'
    elsif errors.blank? && r['on_duty']
      errors = 'found unpermitted parameter: on_duty'
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

  private

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity, :emergency_code, :on_duty)
  end
end
