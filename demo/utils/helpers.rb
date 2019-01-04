def reinstall_apps
  p `adb uninstall com.hfad.messanger`
  p `adb uninstall io.appium.espressoserver.test`
end