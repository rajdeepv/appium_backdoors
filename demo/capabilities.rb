def connected_devices
  lines = %x(adb devices).split("\n")
  start_index = lines.index { |x| x =~ /List of devices attached/ } + 1
  lines[start_index..-1].collect { |l| l.split("\t").first }
end

APPIUM_FORWARDED_PORT = 4567

def android_caps
  {
      platformName: 'Android',
      deviceName: connected_devices.first,
      app: '/Users/rajdeepvarma/AndroidStudioProjects/Messanger/app/build/outputs/apk/debug/app-debug.apk',
      appWaitActivity: '*',
      automationName: 'uiautomator2',
      noSign: true,
      newCommandTimeout: 0,
      skipUnlock: true,
      noReset: true,
      fullReset: false,
      systemPort: APPIUM_FORWARDED_PORT
  }

end