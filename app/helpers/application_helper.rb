module ApplicationHelper
    # If the Rate has not been updated in the last 60 mins, update them before the app begins

    RateWorker.update_rates(nil) if Time.now - Rate.first.updated_at > (60 * 60) # 60 seconds * 60 minutes
end
