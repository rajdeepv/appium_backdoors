require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso(app: 'apidemo.apk')}, false)
@driver.start_driver

scroll_down
@driver.find_element(xpath_by_text("Views")).click

p "****** Count Using WebdriverAPI ********"
p @driver.find_elements({id: 'android:id/text1'}).size
p "****** ************************ ********"

list_view = @driver.find_element({id: 'android:id/list'})

backdoor_item_count = {
    target: "element",
    elementId: e.ref,
    methods: [
        {name: "getTypeface"},
    ]
}

p "****** Count Using Backdoor ViewFunctions ********"
p @driver.execute_script("mobile: backdoor", backdoor_item_count)
p "****** ********************************** ********"


require 'pry'; binding.pry