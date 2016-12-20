require "net/http"
require "uri"

class PetsService
  def post_result(result)
    uri = URI.parse("http://localhost:3000/pets/contest_result")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {"Content-Type" => "application/json"})
    request.body = result.to_json

    http.request(request)
  end
end



