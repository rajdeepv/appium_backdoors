require_relative 'utils/env'

@driver = Appium::Driver.new(caps: android_caps_espresso)
@driver.start_driver


id = @driver.find_element({id:'seekBar'}).ref

require 'pry'; binding.pry
@driver.execute_script("mobile: backdoor", {:target=>"element",elementId:id, :methods=>[{:name=>"getProgress"}]})


