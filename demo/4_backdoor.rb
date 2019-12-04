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

method2 = {
    target: 'activity',
    methods:
        [
            {
                name: "messageView",
            },
            {
                name: "append",
                args:
                    [
                        {value: " Appium", type: 'java.lang.CharSequence'},
                        {value: 0, type: 'int'},
                        {value: 7, type: 'int'}
                    ]
            }
        ]
}

method3 = {
    target: 'activity',
    methods:
        [
            {
                name: "messageView",
            },
            {
                name: "getTextSize",
            }
        ]
}

require 'pry'; binding.pry
@driver.execute_script("mobile: backdoor", method1)
@driver.execute_script("mobile: backdoor", method2)
@driver.execute_script("mobile: backdoor", method3)
