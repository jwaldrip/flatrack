class Flatrack
  module Renderer
    extend ActiveSupport::Autoload

    autoload :Base

    def find(file)
      template = File.exists?(file) ? file : [*pages(file), *layouts(file)][0]
      fail FileNotFound, "could not find #{file}" unless template
      ext = File.extname(template).sub(/\./, '')

      renderer = Base.descendants.find do |descendant|
        descendant.renders?(ext)
      end || fail(RendererNotFound, "could not find a renderer for #{file}")

      renderer.new template
    end

    private

    def pages(file)
      Dir[File.join 'pages', "#{file}*"]
    end

    def layouts(file)
      Dir[File.join 'layouts', "#{file}*"]
    end

    module_function :find, :pages, :layouts
  end
end
