require "net/http"
require "uri"

class Slack
  def initialize(webhook_url)
    @uri = URI.parse(webhook_url)
    @http = Net::HTTP.new(@uri.host, @uri.port)

    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  def post(message)
    req = Net::HTTP::Post.new(@uri.path, "Content-Type" => "application/json")
    req.body = { text: message }.to_json
    res = @http.request(req)

    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
    else
      raise res
    end
  end
end