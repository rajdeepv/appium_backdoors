require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso(app: 'apidemo.apk')}, false)
@driver.start_driver

scroll_down
@driver.find_element(xpath_by_text("Views")).click

list_view = @driver.find_element({id: 'android:id/list'})


backdoor_can_scroll = {
    target: "element",
    elementId: list_view.ref,
    methods: [
        {name: "canScrollVertically",
         args: [{type: 'int', value: "1"}]},
    ]
}

p "****** Can Scroll More? ********"
p @driver.execute_script("mobile: backdoor", backdoor_can_scroll)
p "****** ********************************** ********"


require 'pry'; binding.pry

while @driver.execute_script("mobile: backdoor", backdoor_can_scroll) do
  scroll_down
end