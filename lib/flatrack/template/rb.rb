require 'erubis'

class Flatrack
  module Template
    # The tilt template for rendering Ruby in flatrack
    class Rb < Tilt::ErubisTemplate
      def data
        "<%= #{super} %>"
      end
    end
  end
end

Tilt.prefer Flatrack::Template::Rb, 'rb'
