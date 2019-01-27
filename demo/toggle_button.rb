require_relative 'utils/env'

@driver = Appium::Driver.new(caps: android_caps_espresso.merge(app: 'apidemo.apk'))
@driver.start_driver

@driver.find_element(xpath_by_text("Views")).click
@driver.find_element(xpath_by_text("Buttons")).click

e = @driver.find_element({id: 'button_toggle'})

require 'pry'; binding.pry
@driver.execute_script("mobile: backdoor",
                       {
                           target: "element",
                           elementId: e.ref,
                           methods: [{:name => "isChecked"}]})