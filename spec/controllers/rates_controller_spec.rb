require "rails_helper"

RSpec.describe RatesController, :type => :controller do
  describe "GET #index" do
    it "has a successful response" do
        get :index
        expect(response).to be_successful
    end

    it "successfully gets all rates" do
        get :index
        assert_equal Rate.all, assigns(:rates)
    end
  end

  describe "POST #create" do
    let(:valid_params) do
        {
            rate: {
                currency_1: "AUD",
                currency_2: "USD"
            }
        }
    end

    it "creates a new currency pairing" do
        
        expect { post :create, params: valid_params }.to change(Rate, :count).by(+1)
        expect(response).to redirect_to rates_path
        # expect(response).to be_successful
        # get :index
        # expect(response).to render_template(:new)
        # post :create, :rate => {
        #     :currency_1 => "AUD",
        #     :currency_1 => "USD"
        # }
        # expect(response).to be_successful
        # expect(response).to redirect_to(assigns(:rate))
        # follow_redirect!

        # expect(response).to render_template(:index)
        
    end

    it "creates a new pairing with the correct details" do
        expect {post :create,  :params => valid_params}.to assigns(:rate)
        expect(:rate).to be_a(Rate)
        # post :create,  {:params => valid_params}
        # assigns(:rate).to be_a(Rate)
        # assigns(:rate).to be_persisted
    #     p Rate.last
    #     expect { post :create, params: valid_params }
    #     expect(Rate.last).to have_attributes valid_params[:rate]
    end
  end
end




# it "creates a Widget and redirects to the Widget's page" do
#     get "/widgets/new"
#     expect(response).to render_template(:new)

#     post "/widgets", :widget => {:name => "My Widget"}

#     expect(response).to redirect_to(assigns(:widget))
#     follow_redirect!

#     expect(response).to render_template(:show)
#     expect(response.body).to include("Widget was successfully created.")
#   end

#   it "does not render a different template" do
#     get "/widgets/new"
#     expect(response).to_not render_template(:show)
#   end