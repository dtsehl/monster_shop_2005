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
    @user = User.find(current_user.id)
  end

  def update
    @user = current_user
    @user.update(edit_user_params)
    if @user.save
      flash[:notice] = "Information Updated"
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to "/profile/edit"
    end
  end

  def edit_password
  end

  def update_password
    @user = current_user
    @user.update(password_params)
    if @user.save
      flash[:notice] = "Password Updated"
      redirect_to '/profile'
    end
  end

  def orders
    @orders = User.find(session[:user_id]).orders
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end

  def edit_user_params
    params.permit(:name, :address, :city, :state, :zip, :email)
  end

  def password_params
    params.permit(:password)
  end
end
