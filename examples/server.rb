$: << File.expand_path('../../lib', __FILE__)
require 'sinatra'
require 'allpay'

get '/' do
  client = Allpay::Client.new(merchant_id: '2000132', hash_key: '5294y06JbISpM5x9', hash_iv: 'v77hoKGq4kWxNNIS', mode: :test)
  @params = {
    MerchantID: client.merchant_id,
    MerchantTradeNo: SecureRandom.hex(4),
    MerchantTradeDate: Time.now.strftime('%Y/%m/%d %H:%M:%S'),
    PaymentType: 'aio',
    TotalAmount: 100,
    TradeDesc: '腦袋有動工作室',
    ItemName: '物品一#物品二',
    ReturnURL: 'http://requestb.in/11zuej31',
    ClientBackURL: 'http://requestb.in/11zuej31?inspect',
    ChoosePayment: 'Credit'
  }
  @mac = client.make_mac(@params)
  erb :index
end