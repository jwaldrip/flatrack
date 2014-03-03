require 'flatrack/renderer/base'

class Flatrack::Renderer::Rb < Flatrack::Renderer::Base
  renders :rb

  def render(context)
    eval <<-RUBY, context.get_binding
      r = nil
      evaluator = Thread.start do
        $SAFE  = 3
        r = begin
          #{contents}
        end
      end
      nil while evaluator.alive?
      r
    RUBY
  end
end
