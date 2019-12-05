require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso(app: 'apidemo.apk')}, false)
@driver.start_driver

require 'pry'; binding.pry

@driver.execute_script("mobile:uiautomator", {strategy: 'textContains',
                                              locator: 'App',
                                              index: 0,
                                              action: 'click'})