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

  describe "POST /pets/contest_result" do
    it "updates pets based on contest results" do
      winning_pet = Pet.create!(
          name: "Winner",
          strength: 99,
          agility: 99,
          wit: 99,
          senses: 99,
          experience: 100
      )
      losing_pet = Pet.create!(
          name: "Loser",
          strength: 1,
          agility: 1,
          wit: 1,
          senses: 1,
          experience: 100
      )

      request_body = {winners: [winning_pet.id], losers: [losing_pet.id]}.to_json


      post "/pets/contest_result", request_body, {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}


      expect(response.status).to eq 200
      expect(winning_pet.reload.experience).to eq 115
      expect(losing_pet.reload.experience).to eq 105
    end
  end

  describe "GET /pets/id" do
    it "gets a specific pet" do
      pet = Pet.create!(
          name: "A pet",
          strength: 11,
          agility: 22,
          wit: 33,
          senses: 44,
          experience: 100
      )

      get "/pets/#{pet.id}", {}, {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      expect(response.status).to eq 200

      body = JSON.parse(response.body, symbolize_names: true)
      expect(body.keys).to match_array([:agility, :created_at, :experience, :id, :name, :senses, :strength, :updated_at, :wit])

      expect(body[:name]).to eq "A pet"
      expect(body[:strength]).to eq 11
      expect(body[:agility]).to eq 22
      expect(body[:wit]).to eq 33
      expect(body[:senses]).to eq 44
      expect(body[:experience]).to eq 100
    end
  end
end
