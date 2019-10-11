require "rails_helper"

RSpec.describe RatesController, :type => :controller do
    describe "GET #index" do
        it "has a successful response" do
            get :index
            expect(response).to be_successful
        end

        it "successfully renders the index view" do
            get :index
            expect(response).to render_template("index")
        end

        it "successfully gets all rates" do
            get :index
            assert_equal Rate.all, assigns(:rates)
        end
    end

    describe "POST #create" do
        let(:valid_params) do {
            rate: {
                currency_1: "AUD",
                currency_2: "USD"
            }
        } end

        it "creates a new currency pairing" do
            expect { post :create, params: valid_params }.to change(Rate, :count).by(+1)
            expect(response).to redirect_to rates_path
        end
    end

    describe "DELETE #destroy" do
        let!(:rate) do
            Rate.create({
                currency_1: "AUD",
                currency_2: "USD"
            })
        end

        it 'removes rate from table' do
            expect { 
                delete :destroy, params: { id: rate.id } 
            }.to change { Rate.count }.by(-1)
        end
    end
end