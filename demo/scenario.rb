require 'pry'
require 'appium_lib'
require 'httparty'
require_relative 'capabilities'

`adb uninstall com.hfad.messanger`
`adb uninstall io.appium.uiautomator2.server; adb uninstall io.appium.uiautomator2.server.test`
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
backdoor({name:"raiseToastWithMessage",args:["Welcome to Badoo Automation meetup"]})
backdoor({name:"messageView"},{name:"getTextSize"})
backdoor({name:"messageView"},{name:"getTypeface"},{name:"isItalic"})
backdoor({name:"messageView"},{name:"getTypeface"},{name:"isBold"})
backdoor({name:"messageView"},{name:"setError",args:["Yahoo"]})