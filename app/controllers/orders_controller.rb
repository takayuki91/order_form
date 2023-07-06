class OrdersController < ApplicationController
  
  def new
    @order = Order.new
  end
  
  def confirm
    @order = Order.new(order_params)
  end
  
  def creste
    @order = Order.new(order_params)
    @order.sa
  end
  
  private
  
  def order_params
    params.require(:order).permit(:name)
  end
  
end
