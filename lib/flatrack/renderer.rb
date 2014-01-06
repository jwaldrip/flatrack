module FlatRack
  module Renderer
    extend self
    extend ActiveSupport::Autoload

    autoload :Base

    def find(file)
      template = (Dir[File.join 'pages', "#{file}*"] + Dir[File.join 'layouts', "#{file}*"]).first
      raise FileNotFound, "could not find #{file}" unless template
      ext = File.extname(template).sub(/\./, '')

      Base.descendants.find { |descendant| descendant.renders?(ext)  } ||
        raise(RendererNotFound, "could not find a renderer for #{file}")

      klass = const_get(name.split('_').map(&:capitalize).join, false)
      klass.new template
    rescue NameError, TypeError
      raise RendererNotFound, "could not find a renderer for #{file}"
    end

  end
end