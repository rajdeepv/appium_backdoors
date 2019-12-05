require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso}, false)

@driver.start_driver

method1 = {
    target: 'activity',
    methods:
        [
            {
                name: "raiseToast",
                args: [{value: "Welcome to Heisenbug \n This message was sent by automation code to app under test", type: 'java.lang.String'}]
            }
        ]
}

require 'pry'; binding.pry
@driver.execute_script("mobile: backdoor", method1)
