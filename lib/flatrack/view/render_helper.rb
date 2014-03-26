class Flatrack
  class View
    # View helpers to render partials
    module RenderHelper
      # Renders a partial
      # @param file [Symbol, String]
      # @return [String]
      def render(file)
        Template.find(:partial, file.to_s).render(self)
      end
    end
  end
end
