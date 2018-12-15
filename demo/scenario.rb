require 'pry'
require 'appium_lib'
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

id = @driver.find_element({id:'seekBar'}).ref
@driver.execute_script("mobile: backdoor", {:target=>"element",elementId:id, :methods=>[{:name=>"getProgress"}]})

flash_element({id:'seekBar'})