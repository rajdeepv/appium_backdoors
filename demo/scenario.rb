require 'pry'
require 'appium_lib'
require 'httparty'
require_relative 'capabilities'
require_relative 'helpers'

reinstall_apps

@driver = Appium::Driver.new(caps: android_caps_espresso)

@driver.start_driver


binding.pry

@driver.execute_script("mobile: backdoor",[{name:"messageView"},{name:"getTextSize"}])
@driver.execute_script("mobile: backdoor",[{name:"raiseToast",args:["Love Appium"]}])
@driver.execute_script("mobile: backdoor",[{name:"messageView"},{name:"getTypeface"},{name:"isItalic"}])
@driver.execute_script("mobile: backdoor",[{name:"messageView"},{name:"setError",args:["Lol"]}])