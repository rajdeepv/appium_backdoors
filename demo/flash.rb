require_relative 'utils/env'

@driver = Appium::Driver.new(caps: android_caps_espresso)
@driver.start_driver

def flash_element(e)
  e = @driver.find_element(e)
  id = e.ref
  @driver.execute_script("mobile: flashElement",{element:id})
end

flash_element({id:'seekBar'})