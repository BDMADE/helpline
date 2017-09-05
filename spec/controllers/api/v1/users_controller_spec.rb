require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:valid_user) { FactoryGirl.attributes_for :user }
  let(:invalid_user) { FactoryGirl.attributes_for :user, name: nil }
  let(:user) { User.create! valid_user }

  describe 'GET #index' do
    it 'returns 200 success code' do
      get :index, format: :json
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    context 'valid user' do
      before(:each) do
        get :show, params: { id: user.id }, format: :json
      end

      it 'returns 200 success code' do
        expect(response.status).to eq(200)
      end

      it 'returns the information about a reporter on a hash' do
        expect(json_response[:email]).to eq(user.email)
        expect(json_response[:name]).to eq(user.name)
      end
    end

    context 'invalid user' do
      before(:each) do
        get :show, params: { id: 100 }, format: :json
      end

      it 'returns 204 code' do
        expect(response.status).to eq(204)
      end
    end
  end

  describe 'POST #create' do
    context 'valid user' do
      it 'creates a new User' do
        expect {
          post :create, params: { user: valid_user }, format: :json
        }.to change(User, :count).by(1)
      end

      it 'returns 201 success code' do
        post :create, params: { user: valid_user }, format: :json
        expect(response.status).to eq(201)
      end

      it 'renders the json representation for the user record just created' do
        post :create, params: { user: valid_user }, format: :json
        expect(json_response[:email]).to eql valid_user[:email]
      end
    end

    context 'invalid user' do
      before(:each) do
        post :create, params: { user: invalid_user }, format: :json
      end

      it 'returns 422 error code' do
        expect(response.status).to eq(422)
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on when the user could not be created' do
        expect(json_response[:errors][:name]).to include "can't be blank"
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) { { email: "newmail@example.com" } }
    before(:each) do
      @user = User.create! valid_user
    end

    context 'when user is successfully updated' do
      before(:each) do
        patch :update, params: { id: @user.id, user: new_attributes }, format: :json
      end

      it 'returns 200 success code' do
        expect(response.status).to eq(200)
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:email]).to eql 'newmail@example.com'
      end
    end

    context 'when user is not created' do
      before(:each) do
        patch :update, params: { id: @user.id, user: { email: 'bademail.com' } }, format: :json
      end

      it 'returns 422 code' do
        expect(response.status).to eq(422)
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(json_response[:errors][:email]).to include 'is invalid'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user
      expect {
        delete :destroy, params: { id: user.id }, format: :json
      }.to change(User, :count).by(-1)
    end

    it 'returns 204 code' do
      delete :destroy, params: { id: user.id }, format: :json
      expect(response.status).to eq(204)
    end
  end
end
