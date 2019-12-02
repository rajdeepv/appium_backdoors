require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso(app: 'apidemo.apk')}, false)
@driver.start_driver

scroll_to(xpath_by_text("Views"))
@driver.find_element(xpath_by_text("Views")).click

scroll_to(xpath_by_text("Rating Bar"))
@driver.find_element(xpath_by_text("Rating Bar")).click

sleep 1
element = @driver.find_element(id: 'ratingbar2')
require 'pry'; binding.pry

@driver.execute_script("mobile: backdoor",
                       {
                           target: "element",
                           elementId: element.ref,
                           methods:
                               [
                                   {
                                       name: "setRating",
                                       args: [{type: 'float', value: "4.5"}]
                                   }
                               ]
                       })


element.backdoor([
                     {
                         name: "setRating",
                         args: [{type: 'float', value: "4.5"}]
                     }
                 ])