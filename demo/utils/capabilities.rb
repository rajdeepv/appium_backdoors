def connected_devices
  lines = %x(adb devices).split("\n")
  start_index = lines.index {|x| x =~ /List of devices attached/} + 1
  lines[start_index..-1].collect {|l| l.split("\t").first}
end


def android_caps_espresso(app: 'app-debug.apk/')
  {
      platformName: 'Android',
      deviceName: connected_devices.first,
      app: File.join(File.dirname(__FILE__), '../../'+ app),
      # appWaitActivity: '*',
      automationName: 'espresso',
      newCommandTimeout: 0,
      skipUnlock: true,
      fullReset: false,
      forceEspressoRebuild: false,
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

def android_compose_caps(app: 'compose_playground.apk/')
  {
    platformName: 'Android',
    deviceName: connected_devices.first,
    app: File.join(File.dirname(__FILE__), '../../'+ app),
    # appWaitActivity: '*',
    automationName: 'espresso',
    newCommandTimeout: 0,
    skipUnlock: true,
    fullReset: false,
    forceEspressoRebuild: true,
    showGradleLog: true,
    espressoBuildConfig: '{"additionalAndroidTestDependencies": ["androidx.lifecycle:lifecycle-extensions:2.2.0", "androidx.activity:activity:1.3.1", "androidx.fragment:fragment:1.3.4"]}'
  }
end