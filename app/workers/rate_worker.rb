=begin
* Use a sidekick worker to send off an async request to get the latest rates
* Save this data to the redis database
* On the free tier, cannot change base from EUR, so must do a currencty calculation to get the rate for two differing currency pairs
* I.e. getting an AUD / USD pair
  - Get the EUR / AUD and the EUR / USD
  - Dividing the EUR / USD by the EUR / AUD will give the correct result
=end

class RateWorker
  include Sidekiq::Worker

  def perform
    redis = Redis.new(host: "localhost")

    rates = GetCurrentRateWorker.get_current_rates
    redis.set("rates", rates.to_json)

    Rate.all.each {|pair|
      rate = rates[pair.currency_2] / rates[pair.currency_1]
      pair.update({rate: rate})
      pair.save
    }
  end
end