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

id = @driver.find_element({id:'message'}).ref
hor = @driver.execute_script("mobile: backdoor", {:target=>"element",elementId:id, :methods=>[{:name=>"getLayout"}, {:name=>"getPrimaryHorizontal", args:[{type:"int", value:0}]}]})
line = @driver.execute_script("mobile: backdoor", {:target=>"element",elementId:id, :methods=>[{:name=>"getLayout"}, {:name=>"getLineForOffset", args:[{type:"int", value:0}]}]})
ver = @driver.execute_script("mobile: backdoor", {:target=>"element",elementId:id, :methods=>[{:name=>"getLayout"}, {:name=>"getLineBaseline", args:[{type:"int", value:line}]}]})

def w3c_touch_point(hor,ver)
  selenium_driver = @driver.driver
  f1 = selenium_driver.action.add_pointer_input(:touch, 'finger1')
  f1.create_pointer_move(duration: 0, x: hor, y: ver, origin: ::Selenium::WebDriver::Interactions::PointerMove::VIEWPORT)
  f1.create_pointer_down(:left)
  f1.create_pause(0.2)
  f1.create_pointer_up(:left)
  selenium_driver.perform_actions [f1]
end

w3c_touch_point(hor,ver)
