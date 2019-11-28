require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso(app: 'apidemo.apk')}, false)
@driver.start_driver

@driver.find_element(xpath_by_text("Views")).click

until @driver.find_elements(xpath_by_text("Progress Bar")).any?
  scroll_down
end

@driver.find_element(xpath_by_text("Progress Bar")).click
@driver.find_element(xpath_by_text("1. Incremental")).click

e = @driver.find_element({id: 'progress_horizontal'})

require 'pry'; binding.pry
puts @driver.execute_script("mobile: backdoor",
                       {
                           target: "element",
                           elementId: e.ref,
                           methods: [{name: "getProgress"}]})


puts @driver.execute_script("mobile: backdoor",
                       {
                           target: "element",
                           elementId: e.ref,
                           methods: [{name: "getSecondaryProgress"}]})