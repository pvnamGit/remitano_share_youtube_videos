require 'rails_helper'

RSpec.describe UserController, type: :request do
  describe "#create" do
    context "with valid user parameters" do
      let(:user_params) {  { username: "testuser", password: "password", password_confirmation: "password" } }

      after(:each) do
        User.destroy_all
      end
      it "creates a new user" do
        expect { post '/signup', params: { user: user_params } }.to change(User, :count).by(1)
      end

      it "sets the session's current user id" do
        post '/signup', params: { user: user_params }
        expect(session[:current_user_id]).to eq(User.first.id)
      end

      it "sets the flash notice message" do
        post '/signup', params: { user: user_params }
        expect(flash[:notice]).to eq("User created.")
      end
    end

    context "with invalid user parameters" do
      let(:invalid_user_params) { { username: "testuser", password: "testpassword2", password_confirmation: "testpassword2" } }
      let(:wrong_confirmation_password_params) { { username: "testuser1", password: "testpassword2", password_confirmation: "testpassword1" } }
      before(:each) do
        User.create(:username => 'testuser', :password => 'testpassword2', :password_confirmation => 'testpassword2')
      end
      after(:each) do
        User.destroy_all
      end
      it "does not create a new user because username is existed" do
        expect { post '/signup', params: { user: invalid_user_params } }.not_to change(User, :count)
      end

      it "does not create a new user because wrong password confirmation" do
        expect { post '/signup', params: { user: wrong_confirmation_password_params } }.not_to change(User, :count)
      end

      it "sets the flash notice error message" do
        post '/signup', params: { user: wrong_confirmation_password_params }
        expect(flash[:alert]).to eq("Wrong confirmation password")
      end
    end
  end
end
