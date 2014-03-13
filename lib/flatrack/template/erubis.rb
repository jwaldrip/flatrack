require 'erubis'
module ActionView ; ENCODING_FLAG = '#.*coding[:=]\s*(\S+)[ \t]*' ;end
require 'action_view/buffers'
require 'action_view/template'

class Flatrack
  module Template
    class Erubis < Tilt::ErubisTemplate

      def self.engine_initialized?
        defined? ActionView::Template::Handlers::Erubis
      end

      def prepare
        source = data
        identifier = File.expand_path @file
        handler = ActionView::Template::Handlers::ERB.new
        @template = ActionView::Template.new(source, identifier, handler, {})
      end

      def precompiled_template(locals)
        binding.pry
        # @template.render(@reader)
      end

    end
  end
end

# Tilt.prefer Flatrack::Template::Erubis, 'erb'
