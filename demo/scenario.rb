require 'pry'
require 'appium_lib'
require 'httparty'
require_relative 'capabilities'

Appium::Driver.new(caps: android_caps)
$driver.start_driver

def backdoor(*args)
    url = "http://localhost:#{APPIUM_FORWARDED_PORT}/wd/hub/session/:sessionId/backdoor"
    body = { 'methods' => args }.to_json
    uri = URI(url)
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = body

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    JSON.parse(response.body)['value']
  end

binding.pry