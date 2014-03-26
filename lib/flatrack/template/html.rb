class Flatrack
  module Template
    # The tilt template for rendering HTML in flatrack
    class Html < Tilt::PlainTemplate
      def evaluate(scope, locals, &block)
        super.html_safe
      end
    end
  end
end

Tilt.prefer Flatrack::Template::Html, 'html'
