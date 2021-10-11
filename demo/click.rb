require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso}, false)
@driver.start_driver

element = @driver.find_element(id: 'bold')
element.click

backdoor_item_count = {
  target: "element",
  elementId: element.ref,
  methods: [
    {name: "getTypeface"},
    {name: "isBold"}
  ]
}


b2 = {
  target: "element",
  elementId: element.ref,
  methods: [
    {name: "getTypeface"},
  ]
}

require 'pry'; binding.pry
p @driver.execute_script("mobile: backdoor", backdoor_item_count)

@driver.quit_driver