class Flatrack
  class View
    # View helpers to render partials
    module RenderHelper
      def render(file)
        Template.find(:partial, file.to_s).render(self)
      end
    end
  end
end
