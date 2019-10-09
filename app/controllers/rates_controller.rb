class RatesController < ApplicationController
    # GET /
    def index
      @rates = Rate.all
      @rate = Rate.new
    end
  
    # POST /
    def create
      rate_params = params.require(:rate).permit(:currency_1, :currency_2)
  
      @rate = Rate.new(rate_params)
      if @rate.save
        redirect_to rates_path
      else
        @error = @rate.errors.messages[:currency_1][0]

        # Need another DB call to get all rates on render
        @rates = Rate.all
        render 'index'
      end
    end
  
    # DELETE /:id
    def destroy
      Rate.find(params[:id]).destroy
  
      redirect_to rates_url
    end
  end
  
  
  
