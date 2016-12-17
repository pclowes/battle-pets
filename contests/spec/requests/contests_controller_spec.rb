require "rails_helper"

describe "Contests API" do
  describe "Post /contests" do
    it "creates a contest" do
      post "/contests", {category: "strength"}.to_json, { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }

      expect(response.status).to eq 201

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:category]).to eq "strength"
    end
  end
end