require 'erubis'

class Flatrack
  class Template
    # The tilt template for rendering Ruby in flatrack
    class Rb < Tilt::ErubisTemplate
      private

      def data
        "<%= #{super} %>"
      end
    end
  end
end

Tilt.prefer Flatrack::Template::Rb, 'rb'
