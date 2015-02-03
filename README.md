# Allpay 歐付寶

這是歐付寶 API 的 Ruby 包裝，更多資訊參考他們的[官方文件](https://www.allpay.com.tw/Content/files/%E5%85%A8%E6%96%B9%E4%BD%8D%E9%87%91%E6%B5%81%E4%BB%8B%E6%8E%A5%E6%8A%80%E8%A1%93%E6%96%87%E4%BB%B6.pdf)。

## 安裝

```bash
gem install allpay_client
```

## 使用

```ruby
client = Allpay::Client.new({
  merchant_id: '2000132',
  hash_key: '5294y06JbISpM5x9',
  hash_iv: 'v77hoKGq4kWxNNIS',
  mode: :test
})
client.request '/Cashier/QueryTradeInfo',
  MerchantTradeNo: '0457ce27',
  TimeStamp: Time.now.to_i
```

歐付寶共有 5 個 API：

- /Cashier/AioCheckOut
- /Cashier/QueryTradeInfo
- /Cashier/QueryPeriodCreditCardTradeInfo
- /CreditDetail/DoAction
- /Cashier/AioChargeback

每個 API 有哪些參數建議直接參考歐付寶文件，不過要注意幾點：

- 原本 API 都需要 `MerchantID` 與 `CheckMacValue`，不過 `Client#request` 已經都處理好了，使用時可忽略這兩個參數，正如上述範例一樣。
- `/Cashier/AioCheckOut` 回傳的內容是 HTML，這個請求應該是交給瀏覽器發送的，所以不應該寫出 `client.request '/Cashier/AioCheckOut'`這樣的內容。

## Allpay::Client

實體方法                                                     | 回傳                | 說明
---                                                          | ---                 | ---
`request(path, **params)`                                    | `Net::HTTPResponse` | 發送 API 請求
`make_mac(**params)`                                         | `String`            | 用於產生 `CheckMacValue`，單純做加密，`params` 需要完整包含到 `MerchantID`
`query_trade_info(merchant_trade_number, platform = nil)`    | `Hash`              | `/Cashier/QueryTradeInfo` 的捷徑方法，將 `TimeStamp` 設定為當前時間
`query_period_credit_card_trade_info(merchant_trade_number)` | `Hash`              | `/Cashier/QueryPeriodCreditCardTradeInfo` 的捷徑方法，將 `TimeStamp` 設定為當前時間