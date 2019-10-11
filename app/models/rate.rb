=begin
1. Change currencies to uppercase for display purposes, and to keep hashes consistent
2. Ensure both fields have data entered in them
3. Ensure the uniqueness of the currency pairing - will not add if not unique
4. On create:
  - Ensure the two currencies are both different
  - Get the fairly up-to-date data from redis database. If it does not exist, send off API call to retrieve latest information. If the rate has hash the currencies entered by the user as a key, save the rate of those currencies, else add an error that they have entered the wrong code
=end
  
class Rate < ApplicationRecord
  before_validation :change_to_upcase
  validates :currency_1, :currency_2, presence: true
 
  validates :currency_1, uniqueness: { scope: :currency_2, message: "and Currency 2  pairing has already been added" }

  validate :must_be_different_currencies, :get_current_rate, :on => :create


  private


  scope :between, -> (currency_1, currency_2) do 
    self.find_by_currency_1_and_currency_2(currency_1, currency_2)
  end

  def change_to_upcase
    self.currency_1 = currency_1.upcase
    self.currency_2 = currency_2.upcase
  end

  def must_be_different_currencies
    return if self.currency_1 == ""
    errors.add(:currencies, 'Must Be Unique') if self.currency_1 == self.currency_2
  end

  def get_current_rate
    redis = Redis.new(host: "localhost")
    
    rates = JSON.parse(redis.get("rates"))
    
    rates = GetCurrentRateWorker.get_current_rates if rates.nil?

    if rates.has_key?(self.currency_1) and rates.has_key?(self.currency_2)
      self.rate = rates[self.currency_2] / rates[self.currency_1]
    else
      errors.add(:invalid, "Currency Code Provided") 
    end
  end
end