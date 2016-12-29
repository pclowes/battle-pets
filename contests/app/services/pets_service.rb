require "net/http"
require "uri"

class PetsService
  def post_result(result)
    uri = URI.parse("http://localhost:4000/pets/contest_result")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.path, {"Content-Type" => "application/json"})
    request.body = result.to_json
    http.request(request)
  end

  def get_pets(body)
    uri = URI.parse("http://localhost:4000/pets")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.path, {"Content-Type" => "application/json"})
    request.body = body.to_json

    response = http.request(request)

    response_body = JSON.parse(response.body, symbolize_names: true)
    response_body.map { |p| p.symbolize_keys! }
  end
end



