def connected_devices
  lines = %x(adb devices).split("\n")
  start_index = lines.index {|x| x =~ /List of devices attached/} + 1
  lines[start_index..-1].collect {|l| l.split("\t").first}
end


def android_caps_espresso
  {
      platformName: 'Android',
      deviceName: connected_devices.first,
      app: File.join(File.dirname(__FILE__), '../../app-debug.apk/'),
      # appWaitActivity: '*',
      automationName: 'espresso',
      newCommandTimeout: 0,
      skipUnlock: true,
      fullReset: false,
      forceEspressoRebuild: true,
  }
end

def android_uia_caps
  {
      platformName: 'Android',
      deviceName: connected_devices.first,
      app: 'app-debug.apk',
      appWaitActivity: '*',
      automationName: 'uiautomator2',
      noSign: true,
      newCommandTimeout: 0,
      skipUnlock: true,
      noReset: true,
      fullReset: false,
  }

end