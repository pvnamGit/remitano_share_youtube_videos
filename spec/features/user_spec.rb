require 'rails_helper'
require 'capybara/rspec'

RSpec.describe "Sign up", type: :feature do
  context "render sign up page" do
    it "renders the signup page" do
      visit "/signup"
      expect(page).to have_selector("h1", text: "Create an Account")
    end
  end
  context "create an account" do
    after do
      User.destroy_all
    end
    it "allows users to sign up" do
      visit "/signup"

      fill_in "Username", with: "testuser"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"

      click_button "Create Account"

      expect(page).to have_current_path(root_path)
    end

    it "not allows users to sign up because of wrong confirmation password" do
      visit "/signup"

      fill_in "Username", with: "testuser"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "testpassword"

      click_button "Create Account"

      expect(page).to have_selector("span", text: "Wrong confirmation password")
    end
  end

  context "already have username" do
    before do
      User.create(username: "testuser", password_digest: "password")
    end

    after do
      User.destroy_all
    end
    it 'should not allow to create' do
      visit "/signup"

      fill_in "Username", with: "testuser"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "testpassword"

      click_button "Create Account"

      expect(page).to have_selector("span", text: "Username already created")
    end
  end
end
