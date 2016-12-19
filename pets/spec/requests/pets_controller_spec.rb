require "rails_helper"

describe PetsController do
  describe "POST /pets" do
    it "creates a pet" do
      request_body = {
          name: "A pet",
          strength: 11,
          agility: 22,
          wit: 33,
          senses: 44,
          experience: 100
      }.to_json


      post "/pets", request_body, {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}


      expect(response.status).to eq 201

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:name]).to eq "A pet"
      expect(response_body[:strength]).to eq 11
      expect(response_body[:agility]).to eq 22
      expect(response_body[:wit]).to eq 33
      expect(response_body[:senses]).to eq 44
      expect(response_body[:experience]).to eq 100
    end

    it "renders errors" do
      post "/pets", "", {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}


      expect(response.status).to eq 422

      response_body = JSON.parse(response.body)
      expect(response_body).to match_array([
                                               "Agility can't be blank",
                                               "Experience can't be blank",
                                               "Name can't be blank",
                                               "Senses can't be blank",
                                               "Strength can't be blank",
                                               "Wit can't be blank"
                                           ])
    end
  end
end
