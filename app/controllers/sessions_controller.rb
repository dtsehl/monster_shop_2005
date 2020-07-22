class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.nil? || !user.authenticate(params[:password])
      flash[:error] = "Log in information incorrect, please try again."
      redirect_to request.referrer
    else user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Hello, #{user.name}, you are now logged in."
      redirect_to '/profile' if user.role == "user"
      redirect_to '/merchant/dashboard' if user.role == "merchant"
      redirect_to '/admin/dashboard' if user.role == "admin"
    end
  end
end
