def reinstall_apps
  p `adb uninstall com.hfad.messanger`
  p `adb uninstall io.appium.espressoserver.test`
end

def flash_element(e)
  e = @driver.find_element(e)
  id = e.instance_variable_get("@id")
  @driver.execute_script("mobile: flashElement",{element:id})
end
