class OrdersController < ApplicationController

  def new
    @order = Order.new
    @order.order_products.build
  end

  def confirm

    unless params[:order].present?
      return redirect_to new_order_path
    end

    @order = Order.new(order_params)
    if params.key?(:add_product)
      @order.order_products << OrderProduct.new
      return render :new
    end

    if params.key?(:delete_product)
      filter_order_products
      return render :new
    end

    return render :new if @order.invalid?

  end

  def create
    @order = Order.new(order_params)

    # viewの戻るbtnにvalueを追加
    if params[:button] == "back"
      return render :new
    end

    #　sessionに注文情報を一時保存
    if @order.save
      # メール送信
      # OrderMailer.mail_to_user(@order.id).deliver
      # 非同期処理
      OrderMailerJob.perform_later(@order.id)
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
                  :payment_method_id,
                  :other_comment,
                  :direct_mail_enabled,
                  inflow_source_ids: [],
                  order_products_attributes: %i[product_id quantity]) #シンボルの配列であると明示
  end

  def filter_order_products
    @order.order_products = @order.order_products
                                  .reject
                                  .with_index { |_, index| index == params[:delete_product].to_i}
  end

end
