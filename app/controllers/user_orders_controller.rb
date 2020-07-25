class UserOrdersController < ApplicationController
  def index
    @orders = User.find(session[:user_id]).orders
  end

  def show
  end
end
