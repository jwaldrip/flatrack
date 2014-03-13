require 'erubis'

class Flatrack
  module Template
    class Rb < Tilt::ErubisTemplate

      def data
        "<%= #{super} %>"
      end

    end
  end
end

Tilt.prefer Flatrack::Template::Rb, 'rb'
