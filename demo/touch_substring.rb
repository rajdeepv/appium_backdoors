require_relative 'utils/env'

@driver = Appium::Driver.new(caps: android_caps_espresso)
@driver.start_driver

def w3c_touch_point(hor,ver)
  selenium_driver = @driver.driver
  f1 = selenium_driver.action.add_pointer_input(:touch, 'finger1')
  f1.create_pointer_move(duration: 0, x: hor, y: ver, origin: ::Selenium::WebDriver::Interactions::PointerMove::VIEWPORT)
  f1.create_pointer_down(:left)
  f1.create_pause(0.2)
  f1.create_pointer_up(:left)
  selenium_driver.perform_actions [f1]
end

def tap_subtext_in_text(subtext)
  link_element = @driver.find_element({id: 'textWithLink'})
  link_element_text = link_element.text
  index_of_hyperlink = link_element_text.index(subtext) + subtext.size/2
  top_x = link_element.location.x
  top_y = link_element.location.y
  ref = link_element.ref
  left_padding = @driver.execute_script("mobile: backdoor", {:target => "element", elementId: ref, :methods => [{:name => "getCompoundPaddingLeft"}]})
  hor = @driver.execute_script("mobile: backdoor", {:target => "element", elementId: ref, :methods => [{:name => "getLayout"}, {:name => "getPrimaryHorizontal", args: [{type: "int", value: index_of_hyperlink}]}]})
  line = @driver.execute_script("mobile: backdoor", {:target => "element", elementId: ref, :methods => [{:name => "getLayout"}, {:name => "getLineForOffset", args: [{type: "int", value: index_of_hyperlink}]}]})
  ver = @driver.execute_script("mobile: backdoor", {:target => "element", elementId: ref, :methods => [{:name => "getLayout"}, {:name => "getLineBaseline", args: [{type: "int", value: line}]}]})
  w3c_touch_point(hor + top_x + left_padding, ver + top_y)
end

require 'pry'; binding.pry
tap_subtext_in_text("you")
