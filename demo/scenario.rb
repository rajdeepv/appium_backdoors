require 'pry'
require 'appium_lib'
require 'httparty'
require_relative 'capabilities'
require_relative 'helpers'

reinstall_apps

@driver = Appium::Driver.new(caps: android_caps)

@driver.start_driver


binding.pry




































backdoor({name:"raiseToast",args:["Love Appium"]})
backdoor({name:"messageView"},{name:"getTextSize"})
backdoor({name:"messageView"},{name:"getTypeface"},{name:"isItalic"})
backdoor({name:"messageView"},{name:"getTypeface"},{name:"isBold"})
backdoor({name:"messageView"},{name:"setError",args:["Yahoo"]})

@driver.open_notifications
@driver.find_element({xpath: '//*[contains(@text, "Welcome")]'})