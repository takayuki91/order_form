class AddOtherCommentToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :other_comment, :string, null: false, default: "", limit: 1000, comment: "その他・ご要望" 
  end
end
