require 'rails_helper'

RSpec.describe VideoShareController, type: :feature do
  include LoginHelper
  let(:user) { User.create(username: "testuser", password: "password", password_confirmation: "password") }
  before do
    login(user)
  end

  after do
    VideoShare.destroy_all
    User.destroy_all
  end

  describe "POST create new share" do
    context "when user is not logged in" do
      before(:each) do
        click_button "Logout"
      end
      it "redirects to root path" do
        visit share_path
        expect(page).to have_current_path(root_path)
      end
    end

    context "when user is logged in" do
      context "when URL is invalid" do
        it "displays an error message" do
          visit share_path
          fill_in "url", with: "invalid_url"
          click_button "Submit"
          expect(page).to have_selector("span", text: "Invalid URL")
        end
      end

      context "when URL is valid" do
        let(:valid_url) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
        context "when video has already been shared by the user" do
          it "displays an error message" do
            # Create for the first time
            visit share_path
            fill_in "url", with: valid_url
            click_button "Submit"
            # Create for the second time
            visit share_path
            fill_in "url", with: valid_url
            click_button "Submit"
            expect(page).to have_selector("span", text: "You have already shared this video")
          end
        end
        context "when video has not already been shared by the user" do
          it "redirects to root path and shows video's title" do
            title = "Rick Astley - Never Gonna Give You Up (Official Music Video)"
            visit share_path
            fill_in "url", with: valid_url
            click_button "Submit"
            expect(page).to have_current_path(root_path)
          end
        end
      end
    end
  end

  describe "Open homepage" do
    before do
      VideoShare.create(title: "Test Title 1", description: "Test Description 1", thumbnail_url: "http://example.com/thumbnail1", user_id: user.id)
      VideoShare.create(title: "Test Title 2", description: "Test Description 2", thumbnail_url: "http://example.com/thumbnail2", user_id: user.id)
    end

    it "displays all shared videos" do
      visit root_path
      expect(page).to have_selector("h5", text: "Test Title 1")
      expect(page).to have_selector("h5", text: "Test Title 2")
    end
  end

  describe "Click Share video button" do
    context "when user is not logged in" do
      before do
        click_button "Logout"
      end

      it "redirects to root path" do
        visit share_path
        expect(current_path).to eq(root_path)
      end
    end

    context "when user is logged in" do
      it "renders form input Youtube URL" do
        visit share_path
        expect(page).to have_selector("h1", text: "Share a video")
      end
    end
  end

  describe "My shared page" do
    before do
      @video_1 = VideoShare.create(title: "Test Title", description: "Test Description 1", thumbnail_url: "http://example.com/thumbnail1", user_id: user.id)
    end

    it "displays only the user's videos" do
      visit my_videos_path
      expect(page).to have_selector("h5", text: "Test Title")
    end

    it "displays a link to delete each video" do
      visit my_videos_path
      expect(page).to have_selector('button.btn-delete-video')
    end

    it "deletes the video when the delete link is clicked" do
      visit my_videos_path
      click_button "Delete"
      expect(current_path).to eq(root_path)
      expect(page).not_to have_selector("h5", text: "Test Title")

      visit my_videos_path
      expect(page).not_to have_selector("h5", text: "Test Title")
    end
  end
end
