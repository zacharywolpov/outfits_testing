class SessionsController < ApplicationController
  
  def new
  end

  def create
    session_params = params.permit(:email, :password)
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      redirect_to @user
    else
      render json: { errors: "Login invalid" }
      # flash[:notice] = "Login is invalid. Please log in again."
      redirect_to new_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully been logged out"
    redirect_to root_path
  end
end
