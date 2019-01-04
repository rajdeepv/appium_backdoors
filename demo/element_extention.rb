require_relative 'utils/env'

@driver = Appium::Driver.new(caps: android_caps_espresso)
@driver.start_driver


id = @driver.find_element({id:'seekBar'}).ref
@driver.execute_script("mobile: backdoor", {:target=>"element",elementId:id, :methods=>[{:name=>"getProgress"}]})


message_element_ref = @driver.find_element({id:'message'}).ref
require 'pry'; binding.pry
color = @driver.execute_script("mobile: backdoor", {:target=>"element",elementId:message_element_ref, :methods=>[{:name=>"getCurrentTextColor"}]})
puts "%x" % color


