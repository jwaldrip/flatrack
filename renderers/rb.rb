require 'flatrack/renderer/base'

class Flatrack::Renderer::Rb < Flatrack::Renderer::Base

  renders :rb

  def render(context)
    result    = nil
    evaluator = Thread.start do
      $SAFE  = 3
      result = eval contents, context
    end
    nil while evaluator.alive?
    result
  end

end
