RSpec.describe Rate, :type => :model do
    it "is valid with 2 keys, all uppercase" do
        expect(Rate.create({
            currency_1: "AUD",
            currency_2: "USD"
        })).to be_valid
    end

    it "is valid with 2 keys, all downcase" do
        expect(Rate.create({
            currency_1: "aud",
            currency_2: "usd"
        })).to be_valid
    end

    it "is not valid with an incorrect currency code" do
        expect(Rate.create({
            currency_1: "Long", 
            currency_2: "AUD"
        })).to_not be_valid
    end

    it "will not save a currency pair if it already exists" do
        expect(Rate.create({
            currency_1: "USD", 
            currency_2: "AUD"
        })).to be_valid

        expect(Rate.create({
            currency_1: "USD", 
            currency_2: "AUD"
        })).to_not be_valid
    end

    it "will not save a currency pair both currencies match" do
        expect(Rate.create({
            currency_1: "USD", 
            currency_2: "USD"
        })).to_not be_valid
    end
end
