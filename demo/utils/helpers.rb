def uninstall_apps
  p `adb uninstall com.hfad.messanger`
  p `adb uninstall io.appium.espressoserver.test`
  p `adb uninstall io.appium.android.apis`
end


def xpath_by_text(text)
  {xpath: %(//*[@text="#{text}"])}
end