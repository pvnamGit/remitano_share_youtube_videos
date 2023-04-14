require 'rails_helper'


RSpec.describe UserController do
  describe "#create" do
    context "with valid user parameters" do
      let(:user_params) { { user: { username: "testuser", password: "password" } } }

      it "creates a new user" do
        expect { post :create, params: { user: user_params } }.to change(User, :count).by(1)
      end

      it "redirects to root path" do
        post :signup, params: { user: user_params }
        expect(response).to redirect_to(root_path)
      end

      it "sets the flash notice message" do
        post :signup, params: { user: user_params }
        expect(flash[:notice]).to eq("User created.")
      end
    end

    context "with invalid user parameters" do
      let(:invalid_user_params) do
        { user: { username: "testuser", password: "testpassword2" } }
      end

      it "does not create a new user" do
        expect { post :signup, params: { user: invalid_user_params } }.not_to change(User, :count)
      end

      it "renders the new template" do
        post :signup, params: { user: invalid_user_params }
        expect(response).to render_template(:new)
      end
    end
  end
end
