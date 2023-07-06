class AddTelephoneToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :telephone, :string, null: false, comment: "電話番号"
  end
end
