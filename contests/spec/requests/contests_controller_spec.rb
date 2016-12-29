require "rails_helper"
require "sidekiq/testing"

describe "Contests API" do
  describe "POST /contests" do
    before do
      Sidekiq::Testing::inline!
    end

    it "creates a contest" do
      stub_request(:post, "http://localhost:4000/pets/contest_result").
          with(:body => "{\"losers\":[],\"winners\":[]}").
          to_return(:status => 200, :body => "", :headers => {})

      stub_request(:get, "http://localhost:4000/pets").
          with(:body => "{\"pet_ids\":[1,2]}").
          to_return(:status => 200, :body => "[]", :headers => {})

      request_body = {
          category: :strength,
          pet_ids: [1, 2]
      }.to_json


      post "/contests", request_body, {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}


      expect(response.status).to eq 202
      expect(Contest.count).to eq 1
      expect(Contest.first.pet_ids).to match_array([1, 2])

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:contest][:category]).to eq "strength"
      expect(response_body[:job_id]).to_not be_nil
    end

    it "surfaces errors if creation fails" do
      request_body = {
          category: nil,
      }.to_json


      post "/contests", request_body, {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}


      expect(response.status).to eq 422
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body).to match_array(["Category can't be blank"])

      expect(Contest.count).to eq 0
    end
  end
end