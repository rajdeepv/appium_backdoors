require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso}, false)
@driver.start_driver

element = @driver.find_element(id: 'bold')
element.click
sleep 10
@driver.quit_driver