class Flatrack
  class View
    module RenderHelper
      def render(file)
        Template.find(:partial, file.to_s).render(self)
      end
    end
  end
end
