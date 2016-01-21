class EmergenciesController < ApplicationController
  def create
    e = params['emergency']

    errors = check_severities(e, %w(fire_severity police_severity medical_severity))

    if find_emergency(e['code'])
      render json: { message: { code: ['has already been taken'] } }, status: 422
      return
    end

    return if check_unpermitted_param(%w(id resolved_at))

    missing_numbers = ['can\'t be blank', 'is not a number']
    errors[:fire_severity] = missing_numbers unless e['fire_severity']
    errors[:police_severity] = missing_numbers unless e['police_severity']
    errors[:medical_severity] = missing_numbers unless e['medical_severity']
    errors[:code] = ['can\'t be blank'] unless e['code']

    @emergency = Emergency.new(emergencies_params)
    if errors.blank? && @emergency.save
      render json: { emergency: @emergency }, status: 201
    else
      render json: { message: errors }, status: 422
    end
  end

  def index
    render json: {
      emergencies: Emergency.all,
      full_responses: [1, 3]
    }, status: 200
  end

  def show
    @emergency = find_emergency(params['id'])
    if @emergency
      render json: { emergency: @emergency }, status: 200
    else
      render nothing: true, status: 404
    end
  end

  def update
    return if check_unpermitted_param(%w(code))
    @emergency = find_emergency(params['id'])
    if @emergency.update(emergencies_params)
      render json: { emergency: @emergency }, status: 200
    else
      render nothing: true, status: 422
    end
  end

  private

  def find_emergency(c)
    Emergency.where(code: c).first
  end

  def emergencies_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity, :resolved_at)
  end

  def check_severities(e, types)
    ret = {}
    types.each { |t| ret[t.to_sym] = ['must be greater than or equal to 0'] if e[t].to_i < 0 }
    ret
  end

  def check_unpermitted_param(unpermitted)
    unpermitted.each do |u|
      if params['emergency'][u]
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
