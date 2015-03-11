$: << File.expand_path('../../lib', __FILE__)
require 'bundler/setup'
require 'sinatra'
require 'allpay'

get '/' do
  client = Allpay::Client.new(mode: :test)
  @params = client.generate_checkout_params({
    MerchantTradeNo: SecureRandom.hex(4),
    TotalAmount: 1000,
    TradeDesc: '腦袋有動工作室',
    ItemName: '物品一#物品二',
    ReturnURL: 'http://requestb.in/11zuej31',
    ClientBackURL: 'http://requestb.in/11zuej31?inspect',
    ChoosePayment: 'Credit',
    PeriodAmount: 1000,
    PeriodType: 'D',
    Frequency: 1,
    ExecTimes: 12,
    PeriodReturnURL: 'http://requestb.in/158bu8e1'
  })
  erb :index
end