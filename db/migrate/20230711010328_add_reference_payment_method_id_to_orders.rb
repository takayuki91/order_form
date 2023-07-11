class AddReferencePaymentMethodIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :payment_method, foreign_key: { on_update: :restrict, on_delete: :restrict }, comment: "支払い方法"
  end
end
