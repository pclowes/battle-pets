require "json"
require "uri"
require "net/http"
require "openssl"

def post(url, body)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = false
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(uri.path, {"Content-Type" => "application/json"})
  request.body = body.to_json

  http.request(request)
end

def get(url, body)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = false
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.path, {"Content-Type" => "application/json"})
  request.body = body.to_json

  http.request(request)
end

p "This script demonstrates the battle-pets architecture "
p "First we will POST two pets to the pets api"


pet1 = {
    name: "Buffy",
    strength: 55,
    agility: 44,
    wit: 33,
    senses: 44,
    experience: 100
}

pet1_response = post("http://localhost:4000/pets", pet1)
pet1_body = JSON.parse(pet1_response.body, symbolize_names: true)
p "Pet #1: #{pet1_body}"

pet2 = {
    name: "Fluffy",
    strength: 5,
    agility: 33,
    wit: 22,
    senses: 11,
    experience: 100
}
pet2_response = post("http://localhost:4000/pets", pet2)
pet2_body = JSON.parse(pet2_response.body, symbolize_names: true)
p "Pet #2: #{pet2_body}"

p "Now that we have two pets we will have them compete in a strength contest with a post to contests api"
p "Pet #1 has a strength of #{pet1[:strength]} and experience of #{pet1[:experience]}"
p "Pet #2 has a strength of #{pet2[:strength]} and experience of #{pet2[:experience]}"
p "We expect Pet #1 to win the strength competition and gain 15xp"
p "We expect Pet #2 to lose the strength competition and gain 5xp"

pet1_id = pet1_body[:id]
contestant1 = pet1.merge(pet_id: pet1_id)
pet2_id = pet2_body[:id]
contestant2 = pet2.merge(pet_id: pet2_id)
p contestant1
p contestant2
contest = {
    category: "strength",
    contestants: [contestant1, contestant2]
}

contest_response = post("http://localhost:3000/contests", contest)
contest_body = JSON.parse(contest_response.body, symbolize_names: true)
job_id = contest_body[:job_id]
p "Now the contest is processing in a sidekiq job with id: #{job_id}"


p "We can poll the status of that job with requests to the status endpoint"
message = ""
while message != ("Contest complete" || "Contest failed")
    status_response = get("http://localhost:3000/statuses", job_id: job_id)
    status_body = JSON.parse(status_response.body, symbolize_names: true)
    p "It came back with: #{status_body[:message]}"
    message = status_body[:message]
    sleep 1
end

p1_xp_response = get("http://localhost:4000/pets/#{pet1_id}", nil)
p p1_xp_response
p1_xp_body = JSON.parse(p1_xp_response.body, symbolize_names: true)
p "Our winning pet (id: #{pet1_id}) experience went from 100 to #{p1_xp_body[:experience]}"

p2_xp_response = get("http://localhost:4000/pets/#{pet2_id}", nil)
p2_xp_body = JSON.parse(p2_xp_response.body, symbolize_names: true)
p "Our losing pet (id: #{pet2_id} experience went from 100 to #{p2_xp_body[:experience]}"
