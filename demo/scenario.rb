require 'pry'
require 'appium_lib'
require 'httparty'

def connected_devices
  lines = %x(adb devices).split("\n")
  start_index = lines.index { |x| x =~ /List of devices attached/ } + 1
  lines[start_index..-1].collect { |l| l.split("\t").first }
end

APPIUM_FORWARDED_PORT = 4567
caps={
    platformName: 'Android',
    deviceName: connected_devices.first,
    app: '/Users/rajdeepvarma/AndroidStudioProjects/Messanger/app/build/outputs/apk/debug/app-debug.apk',
    appWaitActivity: '*',
    automationName: 'uiautomator2',
    noSign: true,
    newCommandTimeout: 0,
    skipUnlock: true,
    noReset: true,
    fullReset: false,
    systemPort: APPIUM_FORWARDED_PORT
}

Appium::Driver.new(caps: caps)
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