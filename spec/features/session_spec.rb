require 'rails_helper'
require 'capybara/rspec'

RSpec.describe "SessionController", type: :feature do
  include LoginHelper
  let(:user) { User.create(username: "testuser", password: "password", password_confirmation: "password") }

  after do
    User.destroy_all
  end
  describe "Open login page" do
    it "renders the login page" do
      visit login_path
      expect(page).to have_selector("h1", text: "Log in")
    end
  end

  describe "Login" do
    context "with valid credentials" do
      it "logs the user in and redirects to the root page" do
        visit login_path

        fill_in "Username", with: user.username
        fill_in "Password", with: user.password

        click_button "Log in"

        expect(page).to have_current_path(root_path)
      end
    end

    context "with invalid credentials" do
      it "displays an error message" do
        visit login_path

        fill_in "Username", with: user.username
        fill_in "Password", with: "wrong_password"

        click_button "Log in"

        expect(page).to have_current_path(login_path)
        expect(page).to have_selector("span", text: "Invalid username or password")
      end
    end
  end

  describe "logs the user out" do
    before do
      login(user)
    end

    it "and redirects to the root page" do
      click_button "Logout"

      expect(page).to have_current_path(root_path)
      expect(page).to_not have_selector("p", text: user.username)
    end
  end
end
