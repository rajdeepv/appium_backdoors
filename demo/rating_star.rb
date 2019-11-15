require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso(app: 'apidemo.apk')}, false)
@driver.start_driver

@driver.find_element(xpath_by_text("Views")).click
scroll_down(start_y: 1000, end_y: 100, duration: 0.6)
sleep 1


@driver.find_element(xpath_by_text("Rating Bar")).click

e = @driver.find_element(id: 'ratingbar2')
require 'pry'; binding.pry

@driver.execute_script("mobile: backdoor",
                       {
                           target: "element",
                           elementId: e.ref,
                           methods:
                               [
                                   {
                                       name: "setRating",
                                       args: [{type: 'float', value: "4.5"}]
                                   }
                               ]
                       })