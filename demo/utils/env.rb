require 'pry'
require 'appium_lib'
require_relative 'capabilities'
require_relative 'helpers'

uninstall_apps
`adb shell settings put system pointer_location 1`