require './quickstart'
require 'net/http'
require 'uri'
require 'dotenv/load'

uri = URI.parse(ENV['SLACK_WEBHOOK_URL'])
http = Net::HTTP.new(uri.host, uri.port)

http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

req = Net::HTTP::Post.new(uri.path)
req['Content-Type'] = 'application/json'
req.body = { text: "```#{JSON.pretty_generate($statistics)}```" }.to_json
pp req.body
res = http.request(req)
pp res
