[![Build Status](https://travis-ci.org/tonytonyjan/allpay.svg?branch=master)](https://travis-ci.org/tonytonyjan/allpay)

# Allpay 歐付寶

這是歐付寶 API 的 Ruby 包裝，更多資訊參考他們的[官方文件](https://www.allpay.com.tw/Content/files/%E5%85%A8%E6%96%B9%E4%BD%8D%E9%87%91%E6%B5%81%E4%BB%8B%E6%8E%A5%E6%8A%80%E8%A1%93%E6%96%87%E4%BB%B6.pdf)。

- 這不是 Rails 插件，只是個 API 包裝。
- 使用時只需要傳送需要的參數即可，不用產生檢查碼，`allpay_client` 會自己產生。
- 錯誤代碼太多且會不斷增加，筆者不另行撰寫，官方也建議查網站上的代碼清單。

## 安裝

```bash
gem install allpay_client
```

## 使用

```ruby
test_client = Allpay::Client.new(mode: :test)
production_client = Allpay::Client.new({
  merchant_id: 'MERCHANT_ID',
  hash_key: 'HASH_KEY',
  hash_iv: 'HASH_IV'
})

test_client.request '/Cashier/QueryTradeInfo',
  MerchantTradeNo: '0457ce27',
  TimeStamp: Time.now.to_i
```

歐付寶共有 5 個 API：

- /Cashier/AioCheckOut
- /Cashier/QueryTradeInfo
- /Cashier/QueryPeriodCreditCardTradeInfo
- /CreditDetail/DoAction
- /Cashier/AioChargeback

每個 API 有哪些參數建議直接參考歐付寶文件，注意幾點：

- 使用時不用煩惱 `MerchantID` 與 `CheckMacValue`，正如上述範例一樣。
- `/Cashier/AioCheckOut` 回傳的內容是 HTML，這個請求應該是交給瀏覽器發送的，所以不應該寫出 `client.request '/Cashier/AioCheckOut'` 這樣的內容。

## Allpay::Client

實體方法                                                     | 回傳                | 說明
---                                                          | ---                 | ---
`request(path, **params)`                                    | `Net::HTTPResponse` | 發送 API 請求
`make_mac(**params)`                                         | `String`            | 用於產生 `CheckMacValue`，單純做加密，`params` 需要完整包含到 `MerchantID`
`verify_mac(**params)`                                       | `Boolean`           | 用於檢查收到的參數，其檢查碼是否正確，這用在歐付寶物的 `ReturnURL` 與 `PeriodReturnURL` 參數上。
`query_trade_info(merchant_trade_number, platform = nil)`    | `Hash`              | `/Cashier/QueryTradeInfo` 的捷徑方法，將 `TimeStamp` 設定為當前時間
`query_period_credit_card_trade_info(merchant_trade_number)` | `Hash`              | `/Cashier/QueryPeriodCreditCardTradeInfo` 的捷徑方法，將 `TimeStamp` 設定為當前時間
`generate_checkout_params`                                   | `Hash`              | 用於產生 `/Cashier/AioCheckOut` 表單需要的參數，`MerchantTradeDate`、`MerchantTradeNo`、`PaymentType`，可省略。

## 使用範例

```bash
git clone git@github.com:tonytonyjan/allpay.git
cd allpay
bundle install
ruby examples/server.rb
```
