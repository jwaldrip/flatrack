require 'action_view/buffers'
require 'action_view/helpers/capture_helper'

class Flatrack
  class View
    extend ActiveSupport::Autoload

    autoload :TagHelper
    autoload :LinkHelper
    autoload :RequestHelper

    include AssetExtensions
    include TagHelper
    include LinkHelper
    include RequestHelper
    include ActionView::Helpers::CaptureHelper

    attr_accessor :output_buffer

    def initialize(response)
      @response = response
    end

    def get_binding(&block)
      binding(&block)
    end

    def render(file)
      Template.find(:partial, file.to_s).render(self)
    end

  end
end
