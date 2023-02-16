require 'json'
require 'rest-client'

class CurrencyConverter
  def initialize(api_version=1, date='latest', base_currency='usd', local_currency='clp')
    @api_version = api_version
    @date = date
    @base_currency = base_currency
    @local_currency = local_currency
  end

  def exchange_rate
    begin
      request_url = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@#{@api_version}/#{@date}/currencies/#{@local_currency}/#{@base_currency}.json"
      response = RestClient.get request_url

      JSON.parse(response.body)
    rescue
      {'usd' => 0.0127}
    end
  end
end