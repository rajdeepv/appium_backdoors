require 'pry'
require 'appium_lib'
require 'httparty'
require_relative 'capabilities'
require_relative 'helpers'

reinstall_apps

@driver = Appium::Driver.new(caps: android_caps)
@driver.start_driver


binding.pry
backdoor({name:"raiseToastWithMessage",args:["Welcome to Badoo Automation meetup"]})
backdoor({name:"messageView"},{name:"getTextSize"})
backdoor({name:"messageView"},{name:"getTypeface"},{name:"isItalic"})
backdoor({name:"messageView"},{name:"getTypeface"},{name:"isBold"})
backdoor({name:"messageView"},{name:"setError",args:["Yahoo"]})