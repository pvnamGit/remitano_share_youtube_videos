require 'rails_helper'

RSpec.describe VideoShareController, type: :request do
  describe "Share video" do
    let(:valid_url) { { url: 'https://www.youtube.com/watch?v=wvCK1g3nYbM' } }
    context "create video share with logged in" do
      before(:each) do
        User.create(:username => 'test_login', :password => 'password')
        post '/login', params: { username: 'test_login', password: 'password' }
      end
      it "sets message invalid url" do
        invalid_url = 'https://www.youtube.com/watch?v=abc123/xyz789'
        post '/share', params: { url: invalid_url }
        expect(flash[:error] = "Invalid URL")
      end

      it "get right title and description from url" do
        expected_title = 'Miyamoto Musashi - 7 Ways To Stay Focused'
        expected_description = 'Miyamoto Musashi is considered to be the greatest swordsman ever in the history of Japan'
        video = post '/share', params: valid_url
        expect(video.title).to eq(expected_title)
        expect(video.description).to include(expected_description)
      end

      it "not allow one user share same url" do
        post '/share', params: valid_url
        post '/share', params: valid_url
        expect(flash[:error] = "You have already shared this video")
      end
    end
    context "create video share without logged in" do
      it 'not allowed to share' do
        expect { post '/share', params: valid_url}.to change(VideoShare, :count).by(0)
      end
    end
  end
end
