module Flatrack
  module Renderer
    extend self
    extend ActiveSupport::Autoload

    autoload :Base

    def find(file)
      template = (Dir[File.join 'pages', "#{file}*"] + Dir[File.join 'layouts', "#{file}*"]).first
      raise FileNotFound, "could not find #{file}" unless template
      ext = File.extname(template).sub(/\./, '')

      renderer = Base.descendants.find { |descendant| descendant.renders?(ext)  } ||
        raise(RendererNotFound, "could not find a renderer for #{file}")

      renderer.new template
    end

  end
end