class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def index

  end

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
