require "rails_helper"

RSpec.describe ManagementController, :type => :controller do
    describe "ManagementController GET #index" do
        it "has a successful response" do
            get :index
            expect(response).to be_successful
        end

        it "successfully renders the index view" do
            get :index
            expect(response).to render_template("index")
        end
    end
end


