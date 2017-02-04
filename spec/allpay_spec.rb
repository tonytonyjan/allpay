# encoding: utf-8
require 'spec_helper'
require 'securerandom'

describe Allpay::Client do
  before :all do
    @client = Allpay::Client.new(mode: :test)
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
    expect(res.code).to eq '200'
    expect(res.body.force_encoding('UTF-8')).to include '物品一'
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
    client = Allpay::Client.new(merchant_id: '12345678', hash_key: 'xdfaefasdfasdfa32d', hash_iv: 'sdfxfafaeafwexfe', mode: :test)
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

  it '#verify_mac with more parameters' do
    result = @client.verify_mac AlipayID: nil,
      AlipayTradeNo: nil,
      amount: '1290',
      ATMAccBank: nil,
      ATMAccNo: nil,
      auth_code: '777777',
      card4no: '2222',
      card6no: '431195',
      eci: '0',
      ExecTimes: nil,
      Frequency: nil,
      gwsr: '12303658',
      MerchantID: '2000132',
      MerchantTradeNo: 'R9710358221432568191',
      PayFrom: nil,
      PaymentDate: '2015/05/25 23:37:42',
      PaymentNo: nil,
      PaymentType: 'Credit_CreditCard',
      PaymentTypeChargeFee: '26',
      PeriodAmount: nil,
      PeriodType: nil,
      process_date: '2015/05/25 23:37:42',
      red_dan: '0',
      red_de_amt: '0',
      red_ok_amt: '0',
      red_yet: '0',
      RtnCode: '1',
      RtnMsg: '交易成功',
      SimulatePaid: '0',
      staed: '0',
      stage: '0',
      stast: '0',
      TenpayTradeNo: nil,
      TotalSuccessAmount: nil,
      TotalSuccessTimes: nil,
      TradeAmt: '1290',
      TradeDate: '2015/05/25 23:37:13',
      TradeNo: '1505252337131701',
      WebATMAccBank: nil,
      WebATMAccNo: nil,
      WebATMBankName: nil,
      CheckMacValue: 'B8C4C0524C6D0F8E6F855A072FE4A340'
    expect(result).to eq true
  end
end
