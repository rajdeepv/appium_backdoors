require_relative 'utils/env'

@driver = Appium::Driver.new(caps: android_caps_espresso)
@driver.start_driver

e = @driver.find_element({id: 'seekBar'})
e.flash

require 'pry'; binding.pry