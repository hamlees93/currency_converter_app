module RatesHelper
    def self.rates_stale?(rate)
        # If the Rate has not been updated in the last 60 mins, update them before the app begins

        return if rate.nil?

        RateWorker.update_rates(nil) if Time.now - rate.updated_at > (60 * 60) # 60 seconds * 60 minutes
    end
end
