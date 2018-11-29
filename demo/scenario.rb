require 'pry'
require 'appium_lib'
require 'httparty'
require_relative 'capabilities'
require_relative 'helpers'

reinstall_apps

@driver = Appium::Driver.new(caps: android_caps_espresso)

@driver.start_driver

methods = {
    target: 'activity',
    methods:
        [
            {
                name: "raiseToast",
                args: [{value: "Love Appium", type: 'java.lang.String'}]
            }
        ]
}

methods = {
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
                        {value: "Lol", type: 'java.lang.CharSequence'},
                        {value: 1, type: 'int'},
                        {value: 2, type: 'int'}
                    ]
            }
        ]
}



methods = {
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


binding.pry

@driver.execute_script("mobile: backdoor", methods)
@driver.execute_script("mobile: backdoor", [{name: "raiseToast", args: ["Love Appium"]}])
@driver.execute_script("mobile: backdoor", [{name: "messageView"}, {name: "getTypeface"}, {name: "isItalic"}])
@driver.execute_script("mobile: backdoor", [{name: "messageView"}, {name: "setError", args: ["Lol"]}])