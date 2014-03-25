class Flatrack
  class View
    extend ActiveSupport::Autoload

    autoload :TagHelper
    autoload :LinkHelper
    autoload :RequestHelper
    autoload :CaptureHelper
    autoload :RenderHelper
    autoload :OutputBuffer

    include AssetExtensions
    include TagHelper
    include LinkHelper
    include RequestHelper
    include CaptureHelper
    include RenderHelper
    include ERB::Util

    attr_accessor :output_buffer

    def initialize(response)
      @response = response
      @output_buffer = OutputBuffer.new
      super(response)
    rescue ArgumentError
      super()
    end

  end
end
