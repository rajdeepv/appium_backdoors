require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_compose_caps}, false)
@driver.start_driver

binding.pry