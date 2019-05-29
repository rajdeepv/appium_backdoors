require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso}, false)

@driver.start_driver

element = @driver.find_element({id: 'message'})

color = @driver.execute_script("mobile: backdoor",
                               {
                                   target: "element",
                                   elementId: element.ref,
                                   methods: [
                                       {name: "getCurrentTextColor"}
                                   ]
                               })

require 'pry'; binding.pry

puts "%x" % color


