require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { FactoryGirl.create :user }	 
  before(:each) { request.headers['Accept'] = "application/vnd.helpline.v1" }

  describe "GET #show" do
    before(:each) do      
      get :show, params: { id: user.id, format: :json }
    end

    it "checks if responds successfully" do        
      expect(response).to be_success
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eq(user.email)
      expect(user_response[:name]).to eq(user.name)
    end    
  end
end
