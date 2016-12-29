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

  describe "GET /pets" do
    before do
      @pet1 = Pet.create!(
          name: "Pet 1",
          strength: 99,
          agility: 99,
          wit: 99,
          senses: 99,
          experience: 100
      )
      @pet2 = Pet.create!(
          name: "Pet 2",
          strength: 1,
          agility: 1,
          wit: 1,
          senses: 1,
          experience: 100
      )
    end
    it "returns all pets" do
      get "/pets", {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}


      expect(response.status).to eq 200

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body.length).to eq 2

      response_pet1 = response_body.select { |p| p[:name] == "Pet 1"}.first
      expect(response_pet1[:strength]).to eq 99
      expect(response_pet1[:agility]).to eq 99
      expect(response_pet1[:wit]).to eq 99
      expect(response_pet1[:senses]).to eq 99
      expect(response_pet1[:experience]).to eq 100

      response_pet2 = response_body.select { |p| p[:name] == "Pet 2"}.first
      expect(response_pet2[:strength]).to eq 1
      expect(response_pet2[:agility]).to eq 1
      expect(response_pet2[:wit]).to eq 1
      expect(response_pet2[:senses]).to eq 1
      expect(response_pet2[:experience]).to eq 100
    end

    it "returns pets matching pet_ids" do
      pet3 = Pet.create!(
          name: "Pet 3",
          strength: 20,
          agility: 20,
          wit: 20,
          senses: 20,
          experience: 100
      )


      get "/pets", {pet_ids: [@pet1.id, pet3.id]}, {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}


      expect(response.status).to eq 200

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body.length).to eq 2
      response_ids = response_body.map { |p| p[:id] }
      expect(response_ids).to match_array([@pet1.id, pet3.id])
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
end
