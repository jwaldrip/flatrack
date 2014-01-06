require 'flatrack/renderer/base'

class FlatRack::Renderer::ERB < FlatRack::Renderer::Base

  renders :erb

  def render(context = binding, &block)
    ::ERB.new(contents).result(context, &block)
  end

end