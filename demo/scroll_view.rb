require_relative 'utils/env'

@driver = Appium::Driver.new(caps: android_caps_espresso(app: 'apidemo.apk'))
@driver.start_driver

def scroll_to_button(text)
  scrollview_ref = @driver.find_element({class: 'ScrollView'}).ref
  half_screen_width = @driver.window_size.height / 2
  button_y = @driver.find_element(xpath_by_text(text)).location.y
  backdoor = {target: "element",
              elementId: scrollview_ref,
              methods: [
                  {name: "scrollBy",
                   args: [
                       {type: 'int', value: 0},
                       {type: 'int', value: button_y - half_screen_width}
                   ]
                  }
              ]
  }

  @driver.execute_script("mobile: backdoor", backdoor)
end

require 'pry'; binding.pry
scroll_to_button("Button 60")
