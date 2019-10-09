require 'HTTParty'
  
class Rate < ApplicationRecord
  before_validation :change_to_upcase
 
  validates :currency_1, uniqueness: { scope: :currency_2, message: "and Currency 2  pairing has already been added" }

  validates :currency_1, :currency_2, presence: true

  validate :must_be_different_currencies, :get_current_rate

  private

  scope :between, -> (currency_1, currency_2) do 
      self.find_by_currency_1_and_currency_2(currency_1, currency_2)
  end

  # Change all user input into Upcase to help with API calls and to improve User Interface
  def change_to_upcase
      self.currency_1 = currency_1.upcase
      self.currency_2 = currency_2.upcase
  end

  # API Call to get the current rate for the pair
  def get_current_rate
      response = HTTParty.get("http://data.fixer.io/api/latest?access_key=#{Rails.application.credentials.dig(:fixer)[:access_key]}&symbols=#{self.currency_2},#{self.currency_1}")

      parsed_response = response.parsed_response

      if parsed_response["error"]
          errors.add(:invalid, "Currency Code Provided") if parsed_response["error"]["code"] == 202
      end

      # As we cannot change the base, we have to get the two symbols agaisnt the base of EURO and divide them by each other. Because of this, we still receive success, even if one of them does not work, so we must check the length. If the length is 1, it was unsuccessful, if it is 2, it was successful
      if parsed_response["success"] == true
        case parsed_response["rates"].length
        when 1
            errors.add(:invalid, "Currency Code Provided")
        when 2  
            self.rate = '%.4f' % (parsed_response["rates"][self.currency_2] / parsed_response["rates"][self.currency_1])
        end
      end
  end

  # Ensure currencies are unique
  def must_be_different_currencies
    return if currency_1 = ""
    errors.add(:currencies, 'Must Be Unique') if currency_1 == currency_2
  end
end
