class CartsController < ApplicationController
  def new
  end
  def create
    # render plain text
    # params gained from view/carts/new.html.erb
    render plain: params[:cart].inspect
  end
  def show
  end
end
