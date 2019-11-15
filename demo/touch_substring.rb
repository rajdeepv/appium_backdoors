require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso(app: 'apidemo.apk')}, false)
@driver.start_driver


def tap_subtext_in_text(subtext, locator)
  text_view = @driver.find_element({id: locator})
  full_text = text_view.text
  link_index = full_text.index(subtext) + subtext.size / 2
  top_x = text_view.location.x
  top_y = text_view.location.y
  ref = text_view.ref

  left_padding = @driver.execute_script("mobile: backdoor", {target: "element", elementId: ref, methods: [{name: "getCompoundPaddingLeft"}]})

  # x coordinate of word (link)
  hor = @driver.execute_script("mobile: backdoor", {target: "element", elementId: ref, methods: [{name: "getLayout"}, {name: "getPrimaryHorizontal", args: [{type: "int", value: link_index}]}]})

  # line number at which word(link) exists
  line = @driver.execute_script("mobile: backdoor", {target: "element", elementId: ref, methods: [{name: "getLayout"}, {name: "getLineForOffset", args: [{type: "int", value: link_index}]}]})

  # y coordinate of word (link)
  ver = @driver.execute_script("mobile: backdoor", {target: "element", elementId: ref, methods: [{name: "getLayout"}, {name: "getLineBaseline", args: [{type: "int", value: line}]}]})

  x = hor + top_x + left_padding
  y = ver + top_y
  touch_point(x, y)
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

scroll_down

@driver.find_element(xpath_by_text("Text")).click
@driver.find_element(xpath_by_text("Linkify")).click
require 'pry'; binding.pry
tap_subtext_in_text('415', 'text1')


e = @driver.find_element(id: 'ratingbar_id')

@driver.execute_script("mobile: backdoor",
                       {
                           target: "element",
                           elementId: e.ref,
                           methods:
                               [
                                   {
                                       name: "setRating",
                                       args: [{type: 'float', value: "4.5"}]
                                   }
                               ]
                       })

