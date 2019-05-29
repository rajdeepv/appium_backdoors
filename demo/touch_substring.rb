require_relative 'utils/env'

@driver = Appium::Driver.new({caps: android_caps_espresso.merge(app: 'apidemo.apk')}, false)
@driver.start_driver


def tap_subtext_in_text(subtext, id)
  link_element = @driver.find_element({id: id})
  link_element_text = link_element.text
  index_of_hyperlink = link_element_text.index(subtext) + subtext.size / 2
  top_x = link_element.location.x
  top_y = link_element.location.y
  ref = link_element.ref
  left_padding = @driver.execute_script("mobile: backdoor", {target: "element", elementId: ref, methods: [{name: "getCompoundPaddingLeft"}]})
  hor = @driver.execute_script("mobile: backdoor", {target: "element", elementId: ref, methods: [{name: "getLayout"}, {name: "getPrimaryHorizontal", args: [{type: "int", value: index_of_hyperlink}]}]})
  line = @driver.execute_script("mobile: backdoor", {target: "element", elementId: ref, methods: [{name: "getLayout"}, {name: "getLineForOffset", args: [{type: "int", value: index_of_hyperlink}]}]})
  ver = @driver.execute_script("mobile: backdoor", {target: "element", elementId: ref, methods: [{name: "getLayout"}, {name: "getLineBaseline", args: [{type: "int", value: line}]}]})
  touch_point(hor + top_x + left_padding, ver + top_y)
end

scroll_down

@driver.find_element(xpath_by_text("Text")).click
@driver.find_element(xpath_by_text("Linkify")).click
require 'pry'; binding.pry
tap_subtext_in_text('415', 'text1')
