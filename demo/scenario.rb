require 'pry'
require 'appium_lib'
require 'httparty'
require_relative 'capabilities'
require_relative 'helpers'

reinstall_apps

@driver = Appium::Driver.new(caps: android_caps_espresso)

@driver.start_driver

method1 = {
    target: 'activity',
    methods:
        [
            {
                name: "raiseToast",
                args: [{value: "Love Appium", type: 'java.lang.String'}]
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
                        {value: "Lol", type: 'java.lang.CharSequence'},
                        {value: 1, type: 'int'},
                        {value: 2, type: 'int'}
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

@driver.execute_script("mobile: backdoor", methods)
id = @driver.find_element({id:'id/message'}).instance_variable_get('@id')
@driver.execute_script("mobile: backdoor", {:target=>"element",elementId:id, :methods=>[{:name=>"getTextSize"}]})