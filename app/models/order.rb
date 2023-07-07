class Order < ApplicationRecord

  validates :name, presence: true, length: { maximum: 40 }
  # バリデーターと紐付ける
  validates :email, presence: true, length: { maximum: 100 }, email_format: true
  validates :telephone, presence: true, length: { maximum: 11 }, numericality: { only_integer: true }
  validates :delivery_address, presence: true, length: { maximum: 100 }
  
end
