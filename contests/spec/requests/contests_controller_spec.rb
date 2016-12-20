require "rails_helper"
require "sidekiq/testing"

describe "Contests API" do
  describe "POST /contests" do
    before do
      Sidekiq::Testing::inline!
    end

    it "creates a contest and associated contestants" do
      stub_request(:post, "https://localhost:3000/pets/contest_result").
          with(:body => "{\"losers\":[1],\"winners\":[2]}").
          to_return(:status => 200, :body => "", :headers => {})

      request_body = {
          category: :strength,
          contestants: [
              {
                  pet_id: 1,
                  name: "Contestant 1",
                  strength: 11,
                  agility: 22,
                  wit: 33,
                  senses: 44,
                  experience: 100

              },
              {
                  pet_id: 2,
                  name: "Contestant 2",
                  strength: 44,
                  agility: 33,
                  wit: 22,
                  senses: 11,
                  experience: 100
              }
          ]

      }.to_json


      post "/contests", request_body, {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}


      expect(response.status).to eq 102 #processing
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:contest][:category]).to eq "strength"
      expect(response_body[:job_id]).to_not be_nil

      expect(Contest.count).to eq 1
      expect(Contestant.count).to eq 2
      expect(Contestant.find_by(pet_id: 2).winner).to eq true
      expect(Contestant.find_by(pet_id: 1).winner).to eq false
    end

    it "surfaces errors if creation fails" do
      request_body = {
          category: nil,
          contestants: [
              {
                  pet_id: 1,
                  name: "Contestant 1",
                  strength: 11,
                  agility: 22,
                  wit: 33,
                  senses: 44,
                  experience: 100

              },
              {
                  pet_id: 2,
                  name: "Contestant 2",
                  strength: 44,
                  agility: 33,
                  wit: 22,
                  senses: 11,
                  experience: 100
              }
          ]

      }.to_json


      post "/contests", request_body, {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}


      expect(response.status).to eq 422
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body).to match_array(["Category can't be blank"])

      expect(Contest.count).to eq 0
      expect(Contestant.count).to eq 0
    end
  end
end