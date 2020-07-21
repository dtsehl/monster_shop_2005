class UsersController < ApplicationController
  def profile
    @user = User.find(session[:user_id])
  end

  def new
  end

  def create
    new_user = User.new(user_params)
    if new_user.save
      session[:user_id] = new_user.id
      redirect_to '/profile'
      flash[:success] = 'Registration successful! You are now logged in.'
    else
      redirect_to request.referrer
      flash[:error] = 'You must fill out all fields in order to register!'
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
