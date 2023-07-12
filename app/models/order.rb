require "nkf"

class Order < ApplicationRecord
  # 親テーブルを作成したため
  belongs_to :payment_method

  validates :name, presence: true, length: { maximum: 40 }
  # email_formatバリデーターと紐付ける
  validates :email, presence: true, length: { maximum: 100 }, email_format: true
  validates :telephone, presence: true, length: { maximum: 11 }, numericality: { only_integer: true }
  validates :delivery_address, presence: true, length: { maximum: 100 }
  validates :payment_method_id, presence: true
  validates :other_comment, length: { maximum: 1_000 }
  # boolean型のバリデーション
  validates :direct_mail_enabled, inclusion: { in: [true, false], message: "について選択してください" }

  # コールバック
  after_initialize :format_telephone
  after_initialize :format_email

  private

  def format_telephone
    return if telephone.blank?
    self.telephone = telephone.tr("０-９", "0-9").delete("^0-9")
  end

  def format_email
    return if email.blank?
    self.email = NKF.nkf("-w -Z4", email)
  end

end
