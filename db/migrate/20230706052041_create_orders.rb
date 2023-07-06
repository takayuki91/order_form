class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders, comment: "注文情報" do |t|
      t.string :name, null: false, comment: "お名前"

      t.timestamps
    end
  end
end
