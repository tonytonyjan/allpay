require 'net/http'
require 'json'

module Allpay
  class Client
    PRODUCTION_API_HOST = 'https://payment.allpay.com.tw'.freeze
    TEST_API_HOST = 'http://payment-stage.allpay.com.tw'.freeze

    attr_accessor :merchant_id, :hash_key, :hash_iv, :mode

    def initialize params = {}
      merchant_id = params[:merchant_id]
      hash_key = params[:hash_key]
      hash_iv = params[:hash_iv]
      mode = params[:mode]
      @merchant_id, @hash_key, @hash_iv, @mode = merchant_id, hash_key, hash_iv, mode
    end

    def api_host
      case mode
      when :production then PRODUCTION_API_HOST
      when :test then TEST_API_HOST
      else raise '`mode` is either :test or :production (default)'
      end
    end

    def make_mac params = {}
      raw = params.sort.map!{|k,v| "#{k}=#{v}"}.join('&')
      padded = "HashKey=#{@hash_key}&#{raw}&HashIV=#{@hash_iv}"
      url_encoded = CGI.escape(padded).downcase!
      Digest::MD5.hexdigest(url_encoded).upcase!
    end

    def request path, params = {}
      params[:MerchantID] = @merchant_id
      params[:CheckMacValue] = make_mac(params)
      api_url = URI.join(api_host, path)
      Net::HTTP.post_form api_url, params
    end

    def query_trade_info merchant_trade_number, platform = nil
      params = {
        MerchantTradeNo: merchant_trade_number,
        TimeStamp: Time.now.to_i,
        PlatformID: platform
      }
      params.delete_if{ |k, v| v.nil? }
      res = request '/Cashier/QueryTradeInfo', params
      Hash[res.body.split('&').map!{|i| i.split('=')}]
    end

    def query_period_credit_card_trade_info merchant_trade_number
      res = request '/Cashier/QueryPeriodCreditCardTradeInfo',
              MerchantTradeNo: merchant_trade_number,
              TimeStamp: Time.now.to_i
      JSON.parse(res.body)
    end
  end
end
