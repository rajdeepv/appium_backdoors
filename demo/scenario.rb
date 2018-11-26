require 'pry'
require 'appium_lib'
require 'httparty'
require_relative 'capabilities'
require_relative 'helpers'

reinstall_apps

@driver = Appium::Driver.new(caps: android_caps_espresso)

@driver.start_driver


binding.pry

@driver.execute_script("mobile: swipe", {"element" => "af1cb86c-23c7-4d39-a1d5-351f599419b8", "direction" => "down", "dsda" => "dsasa"})




































backdoor({name:"raiseToast",args:["Love Appium"]})
backdoor({name:"messageView"},{name:"getTextSize"})
backdoor({name:"messageView"},{name:"getTypeface"},{name:"isItalic"})
backdoor({name:"messageView"},{name:"getTypeface"},{name:"isBold"})
backdoor({name:"messageView"},{name:"setError",args:["Yahoo"]})

@driver.open_notifications
@driver.find_element({xpath: '//*[contains(@text, "Welcome")]'})