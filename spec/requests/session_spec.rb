require 'rails_helper'

RSpec.describe SessionController, type: :request do
  describe "Login" do
    context "with valid login credentials" do
      before(:each) do
        @user = User.create(:username => 'test_login', :password => 'password')
        post '/login', params: { username: 'test_login', password: 'password' }
      end

      after(:each) do
        User.destroy_all
      end


      it "sets the user's ID in the session" do
        expect(session[:current_user_id]).to eq(@user.id)
      end

      it "sets a success message" do
        expect(flash[:notice]).to eq("Logged in")
      end
    end

    context "with invalid login credentials" do
      before do
        post '/login', params: { username: 'nonexistentuser', password: 'incorrectpassword' }
      end

      it "does not set the user ID in the session" do
        expect(session[:current_user_id]).to be_nil
      end

      it "sets an error message" do
        expect(flash.now[:error]).to eq("Invalid username or password")
      end
    end
  end

  describe "Log out" do
    before(:each) do
      User.create(:username => 'test_login', :password => 'password')
      post '/login', params: { username: 'test_login', password: 'password' }
      delete '/logout'
    end

    after(:each) do
      User.destroy_all
    end

    it "clears the user ID from the session" do
      expect(session[:current_user_id]).to be_nil
    end
  end
end
