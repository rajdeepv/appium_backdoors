require 'pry'
require 'appium_lib'
require_relative 'capabilities'
require_relative 'helpers'
require_relative 'monkey_patch'

uninstall_apps
`adb shell settings put system pointer_location 1`