def reinstall_apps
  p `adb uninstall com.hfad.messanger`
  p `adb uninstall io.appium.uiautomator2.server; adb uninstall io.appium.uiautomator2.server.test`
  `adb install test_servers/appium-uiautomator2-server-debug-androidTest.apk`
  `adb install test_servers/appium-uiautomator2-server-v0.3.0.apk`
end

def backdoor(*args)
  url = "http://localhost:#{APPIUM_FORWARDED_PORT}/wd/hub/session/:sessionId/backdoor"
  body = {'methods' => args}.to_json
  uri = URI(url)
  req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
  req.body = body

  response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end

  JSON.parse(response.body)['value']
end