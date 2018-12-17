def reinstall_apps
  p `adb uninstall io.cloudgrey.the_app`
  p `adb uninstall io.appium.espressoserver.test`
end

def flash_element(e)
  e = @driver.find_element(e)
  id = e.ref
  @driver.execute_script("mobile: flashElement",{element:id})
end
