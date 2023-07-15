# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ApplicationRecord.transaction do
  Order.delete_all
  PaymentMethod.delete_all
  InflowSource.delete_all
  Product.delete_all

  PaymentMethod.create(id: 1, name: "クレジットカード")
  PaymentMethod.create(id: 2, name: "銀行振込")
  PaymentMethod.create(id: 3, name: "代引き")
  PaymentMethod.create(id: 4, name: "コンビニ支払い")
  PaymentMethod.create(id: 5, name: "郵便為替")

  InflowSource.create(id: 1, name: "検索エンジン")
  InflowSource.create(id: 2, name: "知人の紹介")
  InflowSource.create(id: 3, name: "新聞・雑誌")
  InflowSource.create(id: 4, name: "情報サイト")
  InflowSource.create(id: 5, name: "その他")

  Product.create(id: 1, name: "リーダブルコード", price: 2400)
  Product.create(id: 2, name: "SQL入門", price: 2800)
  Product.create(id: 3, name: "プロを目指す人のためのRuby入門", price: 2980)
  Product.create(id: 4, name: "Javaゼロからはじめるプログラミング", price: 1800)
  Product.create(id: 5, name: "漫画でわかる正規表現", price: 1880)
  Product.create(id: 6, name: "Git使い方入門", price: 2450)

end