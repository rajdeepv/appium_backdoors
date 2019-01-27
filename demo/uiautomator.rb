require_relative 'utils/env'

@driver = Appium::Driver.new(caps: android_caps_espresso.merge(app: 'apidemo.apk'))
@driver.start_driver

require 'pry'; binding.pry
@driver.execute_script("mobile:uiautomator", {strategy: 'textContains', value: 'Access', index: 1, action: 'click'})