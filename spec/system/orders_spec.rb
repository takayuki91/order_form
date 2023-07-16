require 'rails_helper'

RSpec.describe "注文フォーム", type: :system do

  describe "#total_price" do
    let(:params) do
      {
        order_priducts_attributes: [
          {
            product_id: 1,
            quantity: 3
          },
          {
            product_id: 2,
            quantity: 2
          }
        ]
      }
    end

    subject { Order.new(params).total_price }

    it { is_expected.to eq 12800 + 1280 }

    context "消費税に端数が出た場合" do
      # FactoryBotを呼び出す
      before do
        create(:product, id: 99, price: 299)
      end

      let(:params) do
        {
          order_priducts_attributes: [
            {
              product_id: 99,
              quantity: 1
            }
          ]
        }
      end

      # お値段 299 消費税 29.9 切り上げ = 30
      it { is_expected.to eq 329 }
    end
  end

  let(:name) { "サンプルマン" }
  let(:email) { "test@example.com" }
  let(:telephone) { "09012345678" }
  let(:delivery_address) { "東京都葛飾区亀有公園前" }
  let(:other_comment) { "テストコメントです" }

  it "商品を注文できること" do
    visit new_order_path

    fill_in "お名前", with: name
    fill_in "メールアドレス", with: email
    fill_in "電話番号", with: telephone
    fill_in "お届け先住所", with: delivery_address
    select "銀行振込", from: "支払い方法"
    fill_in "その他・ご要望", with: other_comment
    choose "配信を希望する"
    check "検索エンジン"
    check "その他"

    click_on "確認画面へ"

    expect(current_path).to eq confirm_orders_path

    click_on "OK"

    expect(current_path).to eq complete_orders_path
    expect(page).to have_content "#{name}様"

    # 完了ページを再訪すると、入力画面へ戻る
    visit complete_orders_path
    expect(current_path).to eq new_order_path

    order = Order.last
    expect(order.name).to eq name
    expect(order.email).to eq email
    expect(order.telephone).to eq telephone
    expect(order.delivery_address).to eq delivery_address
    expect(order.payment_method_id).to eq 2
    expect(order.other_comment).to eq other_comment
    expect(order.direct_mail_enabled).to eq true
    expect(order.inflow_source_ids).to eq [1, 5]
  end

  context "入力情報に不備がある場合" do
    it "確認画面へ遷移することができない" do
      visit new_order_path

      fill_in "お名前", with: name
      fill_in "メールアドレス", with: email
      fill_in "電話番号", with: telephone
      fill_in "お届け先住所", with: delivery_address
      select "銀行振込", from: "支払い方法"
      fill_in "その他・ご要望", with: other_comment
      choose "配信を希望する"
      check "検索エンジン"
      check "その他"

      click_on "確認画面へ"

      expect(current_path).to eq confirm_orders_path
      expect(page).to have_content "電話は11文字以内で入力してください"
    end

    context "確認画面で戻るを押した場合" do

      it "商品を注文できること" do
        visit new_order_path

        fill_in "お名前", with: name
        fill_in "メールアドレス", with: email
        fill_in "電話番号", with: telephone
        fill_in "お届け先住所", with: delivery_address
        select "銀行振込", from: "支払い方法"
        fill_in "その他・ご要望", with: other_comment
        hoose "配信を希望する"
        check "検索エンジン"
        check "その他"

        click_on "確認画面へ"

        expect(current_path).to eq confirm_orders_path

        click_on "戻る"

        expect(current_path).to eq orders_path

        expect(page).to have_field "お名前", with: name
        expect(page).to have_field "メールアドレス", with: email
        expect(page).to have_field "電話番号", with: telephone
        expect(page).to have_field "お届け先住所", with: delivery_address
        expect(page).to have_select "支払い方法", selected: "銀行振込"
        expect(page).to have_field "その他・ご要望", with: other_comment
        expect(page).to have_checked_field "配信を希望する"

        expect(page).to have_checked_field "検索エンジン"
        expect(page).to have_unchecked_field "知人の紹介"
        expect(page).to have_unchecked_field "新聞・雑誌"
        expect(page).to have_unchecked_field "情報サイト"
        expect(page).to have_checked_field "その他"

        click_on "確認画面へ"

        expect(current_path).to eq confirm_orders_path

        click_on "OK"

        expect(current_path).to eq complete_orders_path
        expect(page).to have_content "#{name}様"

        # 完了ページを再訪すると、入力画面へ戻る
        visit complete_orders_path
        expect(current_path).to eq new_order_path

        order = Order.last
        expect(order.name).to eq name
        expect(order.email).to eq email
        expect(order.telephone).to eq telephone
        expect(order.delivery_address).to eq delivery_address
        expect(order.payment_method_id).to eq 2
        expect(order.other_comment).to eq other_comment
        expect(order.direct_mail_enabled).to eq true
        expect(order.inflow_source_ids).to eq [1, 5]
      end
    end
  end
end
