class Flatrack
  class View
    extend ActiveSupport::Autoload

    autoload :TagHelper
    autoload :LinkHelper
    autoload :RequestHelper
    autoload :CaptureHelper
    autoload :OutputBuffer

    include AssetExtensions
    include TagHelper
    include LinkHelper
    include RequestHelper
    include CaptureHelper

    attr_accessor :output_buffer

    def initialize(response)
      @response = response
      @output_buffer = OutputBuffer.new
    end

    def render(file)
      Template.find(:partial, file.to_s).render(self)
    end

  end
end
