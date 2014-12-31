class Flatrack
  class Template
    # The tilt template for rendering ERB in flatrack
    class Erubis < Tilt::ErubisTemplate
      RENDERS = 'erb'

      extend ActiveSupport::Autoload
      autoload :Handler

      private

      def self.engine_initialized?
        defined? Handler
      end

      def prepare
        @outvar = :output_buffer
        @options.merge!(trim: true)
        @engine = Handler.new(data, options)
      end
    end
  end
end
