# encoding: utf-8
require 'spec_helper'
require 'securerandom'
describe Allpay::Client do
  before :all do
    @client = Allpay::Client.new(merchant_id: '2000132', hash_key: '5294y06JbISpM5x9', hash_iv: 'v77hoKGq4kWxNNIS', mode: :test)
  end

  it '#api /Cashier/AioCheckOut' do
    res = @client.request '/Cashier/AioCheckOut',
      MerchantTradeNo: SecureRandom.hex(4),
      MerchantTradeDate: Time.now.strftime('%Y/%m/%d %H:%M:%S'),
      PaymentType: 'aio',
      TotalAmount: 100,
      TradeDesc: '腦袋有動工作室',
      ItemName: '物品一#物品二',
      ReturnURL: 'http://requestb.in/11zuej31',
      ClientBackURL: 'http://requestb.in/11zuej31?inspect',
      ChoosePayment: 'Credit'
    expect(res.code).to eq '302'
  end

  it '#api /Cashier/QueryTradeInfo' do
    res = @client.request '/Cashier/QueryTradeInfo',
      MerchantTradeNo: '0457ce27',
      TimeStamp: Time.now.to_i
    expect(res.code).to eq '200'
  end

  it '#query_trade_info' do
    result_hash = @client.query_trade_info '0457ce27'
    expect(result_hash.keys).to match_array %w[HandlingCharge ItemName MerchantID MerchantTradeNo
      PaymentDate PaymentType PaymentTypeChargeFee TradeAmt TradeDate TradeNo TradeStatus CheckMacValue]
  end

  it '#query_period_credit_card_trade_info' do
    result_hash = @client.query_period_credit_card_trade_info '0457ce27'
    expect(result_hash.keys).to match_array %w[MerchantID MerchantTradeNo TradeNo RtnCode PeriodType
      Frequency ExecTimes PeriodAmount amount gwsr process_date auth_code card4no
      card6no TotalSuccessTimes TotalSuccessAmount ExecLog]
  end

  it '#make_mac' do 
    client = Allpay::Client.new(merchant_id: '12345678', hash_key: 'xdfaefasdfasdfa32d', hash_iv: 'sdfxfafaeafwexfe')
    mac = client.make_mac({
      ItemName: 'sdfasdfa',
      MerchantID: '12345678',
      MerchantTradeDate: '2013/03/12 15:30:23',
      MerchantTradeNo: 'allpay_1234',
      PaymentType: 'allpay',
      ReturnURL: 'http:sdfasdfa',
      TotalAmount: '500',
      TradeDesc: 'dafsdfaff'
    })
    expect(mac).to eq '40D9A6C00A4A78A300ED458237071BDA'
  end

  it '#verify_mac' do
    result = @client.verify_mac RtnCode: '1',
      PaymentType: 'Credit_CreditCard',
      TradeAmt: '700',
      PaymentTypeChargeFee: '14',
      PaymentDate: '2015/02/07 14:21:00',
      SimulatePaid: '0',
      CheckMacValue: '3AF270CCCFA58CA0349F4FD462E21643',
      TradeDate: '2015/02/07 14:20:47',
      MerchantID: '2000132',
      TradeNo: '1502071420478656',
      RtnMsg: '交易成功',
      MerchantTradeNo: '355313'
    expect(result).to eq true
  end

  it '#verify_mac with string hash' do
    result = @client.verify_mac 'RtnCode' => '1',
      'PaymentType' => 'Credit_CreditCard',
      'TradeAmt' => '700',
      'PaymentTypeChargeFee' => '14',
      'PaymentDate' => '2015/02/07 14:21:00',
      'SimulatePaid' => '0',
      'CheckMacValue' => '3AF270CCCFA58CA0349F4FD462E21643',
      'TradeDate' => '2015/02/07 14:20:47',
      'MerchantID' => '2000132',
      'TradeNo' => '1502071420478656',
      'RtnMsg' => '交易成功',
      'MerchantTradeNo' => '355313'
    expect(result).to eq true
  end
end
