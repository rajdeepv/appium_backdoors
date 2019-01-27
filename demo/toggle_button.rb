require_relative 'utils/env'

@driver = Appium::Driver.new(caps: android_caps_espresso.merge(app: 'apidemo.apk'))
@driver.start_driver


require 'pry'; binding.pry
e = @driver.find_element({id: 'button_toggle'})
@driver.execute_script("mobile: backdoor",
                       {
                           target: "element",
                           elementId: e.ref,
                           methods: [{:name => "isChecked"}]})