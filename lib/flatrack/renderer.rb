class Flatrack
  module Renderer
    extend ActiveSupport::Autoload

    autoload :Base

    def find(type, file)
      template = find_by_type type, file
      fail FileNotFound, "could not find #{file}" unless template
      ext = File.extname(template).sub(/\./, '')
      renderer = Base.descendants.find do |descendant|
        descendant.renders?(ext)
      end || fail(RendererNotFound, "could not find a renderer for #{file}")

      renderer.new template
    end

    private

    def find_by_type(type, file)
      if File.exists?(file)
        file
      else
        Dir[File.join type.to_s.pluralize, "#{file}*"].first
      end
    end

    module_function :find, :find_by_type
  end
end
