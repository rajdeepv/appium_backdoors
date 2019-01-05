def uninstall_apps
  p `adb uninstall com.hfad.messanger`
  p `adb uninstall io.appium.espressoserver.test`
  p `adb uninstall io.appium.android.apis`
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


def scroll_down
  selenium_driver = @driver.driver
  f1 = selenium_driver.action.add_pointer_input(:touch, 'finger1')
  f1.create_pointer_move(duration: 0, x: 200, y: 500, origin: ::Selenium::WebDriver::Interactions::PointerMove::VIEWPORT)
  f1.create_pointer_down(:left)
  f1.create_pointer_move(duration: 1, x: 200, y: 200, origin: ::Selenium::WebDriver::Interactions::PointerMove::VIEWPORT)
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
