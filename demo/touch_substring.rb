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

  left_padding = text_view.backdoor([{name: "getCompoundPaddingLeft"}])

  # x coordinate of word (link)
  hor = text_view.backdoor([{name: "getLayout"}, {name: "getPrimaryHorizontal", args: [{type: "int", value: link_index}]}])

  # line number at which word(link) exists
  line = text_view.backdoor([{name: "getLayout"}, {name: "getLineForOffset", args: [{type: "int", value: link_index}]}])

  # y coordinate of word (link)
  ver = text_view.backdoor([{name: "getLayout"}, {name: "getLineBaseline", args: [{type: "int", value: line}]}])

  x = hor + top_x + left_padding
  y = ver + top_y
  adb_touch_point(x, y)
end

@driver.find_element(xpath_by_text("Text")).click
@driver.find_element(xpath_by_text("Linkify")).click
require 'pry'; binding.pry
tap_subtext_in_text('415', 'text1')