module Selenium
  module WebDriver
    class Element
      def flash
        bridge.flash(@id)
      end

      def backdoor(methods)
        bridge.backdoor(methods, @id)
      end
    end
  end
end

Appium::Core::Base::Bridge::W3C.class_eval do
  def flash(element)
    execute :execute_script, {}, {script: "mobile: flashElement", args: {element: element, durationMillis:100, repeatCount:20}}
  end

  def backdoor(methods, id)
    execute :execute_script, {}, {script: "mobile: backdoor", args: {target: "element", elementId: id, methods: methods}}
  end
end
