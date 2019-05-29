def uninstall_apps
  `adb uninstall com.hfad.messanger`
  `adb uninstall io.appium.espressoserver.test`
  `adb uninstall io.appium.android.apis`
end

def silenced
  stderr = STDERR
  STDERR.reopen('/dev/null', 'w')
  yield
ensure
  $stderr = stderr
end


def xpath_by_text(text)
  {xpath: %(//*[@text="#{text}"])}
end

def touch_point(hor, ver)
  selenium_driver = @driver.driver
  f1 = selenium_driver.action.add_pointer_input(:touch, 'finger1')
  f1.create_pointer_move(duration: 0, x: hor, y: ver, origin: ::Selenium::WebDriver::Interactions::PointerMove::VIEWPORT)
  f1.create_pointer_down(:left)
  f1.create_pause(0.2)
  f1.create_pointer_up(:left)
  selenium_driver.perform_actions [f1]
end


def scroll_down(start_y:500, end_y:200, duration:1)
  selenium_driver = @driver.driver
  f1 = selenium_driver.action.add_pointer_input(:touch, 'finger1')
  f1.create_pointer_move(duration: 0, x: 200, y: start_y, origin: ::Selenium::WebDriver::Interactions::PointerMove::VIEWPORT)
  f1.create_pointer_down(:left)
  f1.create_pointer_move(duration: duration, x: 200, y: end_y, origin: ::Selenium::WebDriver::Interactions::PointerMove::VIEWPORT)
  f1.create_pointer_up(:left)
  selenium_driver.perform_actions [f1]
end


# list_view = @driver.find_element({id:'android:id/list'})
# backdoor_scroll_list_view = {:target => "element",
#                              elementId: list_view.ref,
#                              :methods => [
#                                  {name: "scrollListBy",
#                                   args: [
#                                       {type: 'int', value: 200},
#                                   ]
#                                  }
#                              ]
# }
#
# @driver.execute_script("mobile: backdoor", backdoor_scroll_list_view)
