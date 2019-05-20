module MonkeyPatch
  module Selenium
    module WebDriver
      module Element
        def flash
          bridge.flash(@id)
        end
      end

    end
  end
end

Selenium::WebDriver::Element.prepend(MonkeyPatch::Selenium::WebDriver::Element)

Appium::Core::Base::Bridge::W3C.class_eval do
  def flash(element) # rubocop:disable Naming/MethodName
    execute :execute_script, {}, {script: "mobile: flashElement", args: {element: element}}
  end
end
