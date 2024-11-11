require 'net/http'
require 'json'

class CurrencyService
  API_BASE_URL = 'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json'.freeze

  def self.get_exchange_rates(target_currencies)
    uri = URI(API_BASE_URL)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)['usd']
    rates = target_currencies.each_with_object({}) do |currency, acc|
      acc[currency] = data[currency] if data.key?(currency)
    end
    raise 'No valid exchange rates retrieved' if rates.empty?

    rates
  rescue StandardError => e
    Rails.logger.error("Failed to fetch exchange rates: #{e.message}")
    raise 'Failed to fetch exchange rates'
  end
end