require_relative 'utils/env'

# Instantiate driver
@driver = Appium::Driver.new({caps: android_caps_espresso}, false)

# Start driver
@driver.start_driver

# Call element Backdoor
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


@driver.find_element({id: 'message'}).backdoor([{name: "getCurrentTextColor"}])
