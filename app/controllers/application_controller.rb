class ApplicationController < ActionController::Base

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authorize
    redirect_to new_session_path unless current_user
    # unless User.find(session[:user_id]) if session[:user_id]
  end

  # Currently not being used – may be deleted
  def render_unprocessable_entity_response(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

end
