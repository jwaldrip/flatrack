class Flatrack
  class View
    # View helpers to render partials
    module RenderHelper
      # Renders a partial
      # @param file [Symbol, String]
      # @return [String]
      def render(file, *args)
        Template.find(config.site_root, :partial, nil, file.to_s).render(self, *args)
      end
    end
  end
end
