class OrdersController < ApplicationController

  def new
    @order = Order.new
  end

  def confirm
    if params[:order].present?
      @order = Order.new(order_params)
      return render :new if @order.invalid?
    else
      # ユーザーがリロードした時
      return redirect_to new_order_path
    end
  end

  def create
    @order = Order.new(order_params)

    # viewの戻るbtnにvalueを追加
    if params[:button] == "back"
      return render :new
    end

    #　sessionに注文情報を一時保存
    if @order.save
      session[:order_id] = @order.id
      return redirect_to complete_orders_path
    end

    render :confirm
  end

  def complete
    @order = Order.find_by(id: session[:order_id])

    # ユーザーがリロードした時
    return redirect_to new_order_path if @order.blank?

    # sessionの注文情報を削除
    session[:order_id] = nil
  end

  private

  def order_params
    params.require(:order)
          .permit(:name,
                  :email,
                  :telephone,
                  :delivery_address,
                  :payment_method_id)
  end

end
