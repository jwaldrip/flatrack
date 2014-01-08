require 'flatrack/renderer/base'

class Flatrack::Renderer::Html < Flatrack::Renderer::Base

  renders :html

  def render(*args)
    contents
  end

end