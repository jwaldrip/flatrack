require 'flatrack/renderer/base'

class FlatRack::Renderer::Html < FlatRack::Renderer::Base

  renders :html

  def render(*args)
    contents
  end

end