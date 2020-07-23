class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to '/admin/dashboard' if current_user.admin?
      redirect_to '/merchant/dashboard' if current_user.merchant?
      redirect_to '/profile' if current_user.user?
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user.nil? || !user.authenticate(params[:password])
      flash[:error] = "Log in information incorrect, please try again."
      redirect_to request.referrer
    elsif user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Hello, #{user.name}, you are now logged in."
      redirect_to '/admin/dashboard' if current_user.admin?
      redirect_to '/merchant/dashboard' if current_user.merchant?
      redirect_to '/profile' if current_user.user?
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = "You have successfully logged out!"
    redirect_to '/'
  end
end
