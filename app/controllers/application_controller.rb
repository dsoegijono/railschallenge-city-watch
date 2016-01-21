class ApplicationController < ActionController::Base
  respond_to :json

  def new
    render json: { message: 'page not found' }, status: 404
  end

  def edit
    render json: { message: 'page not found' }, status: 404
  end

  def destroy
    render json: { message: 'page not found' }, status: 404
  end

  def check_unpermitted_param(unpermitted, params)
    unpermitted.each do |u|
      if params[u]
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
