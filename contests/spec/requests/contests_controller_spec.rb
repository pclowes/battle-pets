require "rails_helper"

describe "Contests API" do
  describe "Post /contests" do
    it "creates a contest and associated contestants" do
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

      expect(response.status).to eq 201
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:category]).to eq "strength"

      expect(Contest.count).to eq 1
      expect(Contestant.count).to eq 2
    end
  end
end