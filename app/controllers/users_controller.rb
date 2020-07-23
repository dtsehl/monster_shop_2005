class UsersController < ApplicationController

  def show
    @user = current_user
    render file: "/public/404" if !current_user
  end

  def new
  end

  def create
    @new_user = User.new(user_params)
    if @new_user.save
      session[:user_id] = @new_user.id
      redirect_to '/profile'
      flash[:success] = 'Registration successful! You are now logged in.'
    else
      flash[:error] = @new_user.errors.full_messages.first
      render :new
    end
  end

  def edit

  end

  def update
    @user = current_user
    @user.update(edit_user_params)
    if @user.save
      flash[:notice] = "Information Updated"
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end

  def edit_user_params
    params.permit(:name, :address, :city, :state, :zip, :email)
  end
end
