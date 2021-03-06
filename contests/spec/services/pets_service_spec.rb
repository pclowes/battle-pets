require "rails_helper"

describe PetsService do
  describe "#post_result" do
    it "takes a result and posts it to the pets api results endpoint" do
      stub_request(:post, "http://localhost:4000/pets/contest_result").
          with(:body => "{\"losers\":[3,4],\"winners\":[1,2]}",
               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "", :headers => {})

      result = {losers: [3,4], winners: [1,2]}


      response = PetsService.new.post_result(result)

      expect(response.class).to eq(Net::HTTPOK)
    end
  end

  describe "#get_pets" do
    it "takes an array of pet_ids and GETs them from the pets api" do
      stub_request(:post, "http://localhost:4000/pets/contest_result").
          with(:body => "{\"pet_ids\":[1,2,3]}").
          to_return(:status => 200, :body => "", :headers => {})

      response = PetsService.new.post_result({pet_ids: [1, 2, 3]})

      expect(response.class).to eq(Net::HTTPOK)
    end
  end
end
