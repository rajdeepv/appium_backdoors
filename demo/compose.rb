require_relative 'utils/env'

def android_compose_caps(app: 'compose_playground.apk/')
  {
    platformName: 'Android',
    deviceName: connected_devices.first,
    app: File.join(File.dirname(__FILE__), '../' + app),
    automationName: 'espresso',
    newCommandTimeout: 0,
    skipUnlock: true,
    fullReset: false,
    forceEspressoRebuild: true,
    showGradleLog: true,
    espressoBuildConfig: '{"additionalAndroidTestDependencies": ["androidx.lifecycle:lifecycle-extensions:2.2.0", "androidx.activity:activity:1.3.1",  "androidx.fragment:fragment:1.2.0"]}'
  }
end

@@driver = Appium::Driver.new({ caps: android_compose_caps }, false)
@@driver.start_driver
@@driver.update_settings({'driver' => 'compose'})

binding.pry