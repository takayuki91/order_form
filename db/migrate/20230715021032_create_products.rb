class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products, comment: "商品マスタ" do |t|
      t.string :name, comment: "商品名"
      t.integer :price, comment: "価格"

      t.timestamps
    end
  end
end
