require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso.merge(app: 'apidemo.apk')}, false)
@driver.start_driver

require 'pry'; binding.pry

@driver.execute_script("mobile:uiautomator", {strategy: 'textContains', locator: 'Access', index: 1, action: 'getVisibleBounds'})