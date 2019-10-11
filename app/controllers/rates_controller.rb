  # Send a worker away to get the latest rates everytime a new currency pair is created or deleted. The worker will perform an async API call to get the latest rates

class RatesController < ApplicationController
  # GET /
  def index
    @rates = Rate.all
    @rate = Rate.new
    RatesHelper.rates_stale?(@rates[0])
  end

  # POST /
  def create
    rate_params = params.require(:rate).permit(:currency_1, :currency_2)
    @rate = Rate.new(rate_params)

    if @rate.save
      RateWorker.perform_async

      redirect_to rates_path
    else
      @rates = Rate.all
      
      render 'index'
    end
  end

  # DELETE /:id

  def destroy
    Rate.find(params[:id]).destroy

    RateWorker.perform_async

    redirect_to rates_url
  end
end