require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso}, false)

@driver.start_driver

color = @driver.execute_script("mobile: backdoor",
                               {
                                   target: "element",
                                   elementId: @driver.find_element({id: 'message'}).ref,
                                   methods: [
                                       {name: "getCurrentTextColor"}
                                   ]
                               })

require 'pry'; binding.pry

puts "%x" % color


