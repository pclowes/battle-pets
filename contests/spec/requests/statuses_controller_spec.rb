require "rails_helper"
require "sidekiq/testing"

describe "Statuses API" do
  describe "GET /statuses" do
    it "returns a status of 'processing' for an ongoing asynchronous job" do
      class_double(Sidekiq::Status, complete?: false, failed?: false).as_stubbed_const
      job_id = "job123"

      get "/statuses", {job_id: job_id}

      expect(response.status).to eq 202
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq "Contest processing"
    end

    it "returns a server error for a failed asynchronous job" do
      class_double(Sidekiq::Status, complete?: false, failed?: true).as_stubbed_const
      job_id = "job123"

      get "/statuses", {job_id: job_id}

      expect(response.status).to eq 500
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq "Contest failed"
    end

    it "returns a status of ok for a completed asynchronous job" do
      class_double(Sidekiq::Status, complete?: true, failed?: false).as_stubbed_const
      job_id = "job123"

      get "/statuses/", {job_id: job_id}

      expect(response.status).to eq 200
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq "Contest complete"
    end
  end
end