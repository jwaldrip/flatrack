class Flatrack
  module Template
    class Html < Tilt::PlainTemplate
      def evaluate(scope, locals, &block)
        super.html_safe
      end
    end
  end
end

Tilt.prefer Flatrack::Template::Html, 'html'
