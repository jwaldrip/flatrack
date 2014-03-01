require 'flatrack/renderer/base'

class Flatrack::Renderer::ERB < Flatrack::Renderer::Base
  renders :erb

  def render(context = binding, &block)
    ::ERB.new(contents).result context.get_binding(&block)
  end
end
