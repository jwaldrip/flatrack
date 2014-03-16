class Flatrack
  module Template
    class Erubis < Tilt::ErubisTemplate
      extend ActiveSupport::Autoload
      autoload :Handler

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

Tilt.prefer Flatrack::Template::Erubis, 'erb'

__END__

@output_buffer.concat(link_to('example', 'http://example1.org')).html_safe
@output_buffer.concat(''.freeze)
@output_buffer.concat(link_to('http://example2.org')).html_safe
@output_buffer.concat(''.freeze)
@output_buffer << link_to('http://example3.org') do
  @output_buffer.concat('Hello World').html_safe.freeze
end
@output_buffer << link_to('http://example4.org') do
  @output_buffer.concat('').html_safe.freeze
  @output_buffer.concat(image_tag('http://example.org/sample.jpg')).html_safe
  @output_buffer.concat(''.freeze)
end
@output_buffer << link_to('http://example5.org') do
  @output_buffer.concat('').html_safe.freeze
  @output_buffer.concat(image_tag('sample.jpg')).html_safe; @output_buffer.concat(''.freeze)
end
output_buffer = @output_buffer.to_s