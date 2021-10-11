# BMA Code Component: <Framework: Android: UI Inspector>
require 'webrick'
module ViewInspector
  INSPECTOR_PORT = 4725

  class Hierarchy < WEBrick::HTTPServlet::FileHandler
    def prevent_caching(res)
      res['ETag'] = nil
      res['Last-Modified'] = Time.now + 100**4
      res['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0'
      res['Pragma'] = 'no-cache'
      res['Expires'] = Time.now - 100**4
    end

    SCREENSHOT_PATH = "#{__dir__}/resources/screenshot.png"
    VIEW_XML_PATH = "#{__dir__}/resources/tree.xml"

    def do_GET(req, res) # rubocop: disable Naming/MethodName
      if req.path == '/'
        FileUtils.rm_f(VIEW_XML_PATH)
        FileUtils.rm_f(SCREENSHOT_PATH)
        File.open(VIEW_XML_PATH, 'w') { |f| f.write(@@driver.get_source) }
        @@driver.screenshot(SCREENSHOT_PATH)
      end

      super
      prevent_caching(res)
    end
  end

  class Server
    def initialize
      @webrick_server = WEBrick::HTTPServer.new(Port:      INSPECTOR_PORT,
                                                Logger:    WEBrick::Log.new("/dev/null"),
                                                AccessLog: [])
      @webrick_server.mount("/", Hierarchy, __dir__)
    end

    def start
      return if @running

      puts("Starting InspectorServer")
      Thread.new { @webrick_server.start }
      @running = true
    end

    def stop
      @webrick_server.stop
      @running = false
      @webrick_server = nil
    end
  end

  def self.launch
    @inspector ||= ViewInspector::Server.new.start
    url = "http://localhost:#{INSPECTOR_PORT}"
    puts "Inspector url: #{url}"
    `open #{url} || xdg-open #{url}`
  end
end
