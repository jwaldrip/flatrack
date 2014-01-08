require 'flatrack/renderer/base'

class Flatrack::Renderer::ERB < Flatrack::Renderer::Base

  renders :erb

  def render(context = binding, &block)
    ::ERB.new(contents).result(context, &block)
  end

end