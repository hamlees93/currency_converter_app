# API call to get the current rate from fixer. Will return all pairings as a hash

class GetCurrentRateWorker
  def self.get_current_rates
    response = HTTParty.get("http://data.fixer.io/api/latest?access_key=#{Rails.application.credentials.dig(:fixer)[:access_key]}")
  
    return response.parsed_response["rates"]
  end
end