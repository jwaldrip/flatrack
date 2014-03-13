class Flatrack
  class View
    module CaptureHelper

      private

      def capture(*args)
        value  = nil
        buffer = with_output_buffer { value = yield(*args) }
        if string = buffer.presence || value and string.is_a?(String)
          ERB::Util.html_escape string
        end
      end

      # Use an alternate output buffer for the duration of the block.
      # Defaults to a new empty string.
      def with_output_buffer(buf = nil) #:nodoc:
        unless buf
          buf = OutputBuffer.new
          buf.force_encoding(output_buffer.encoding) if output_buffer
        end
        self.output_buffer, old_buffer = buf, output_buffer
        yield
        output_buffer
      ensure
        self.output_buffer = old_buffer
      end

      # Add the output buffer to the response body and start a new one.
      def flush_output_buffer #:nodoc:
        if output_buffer && !output_buffer.empty?
          response.stream.write output_buffer
          self.output_buffer = output_buffer.respond_to?(:clone_empty) ? output_buffer.clone_empty : output_buffer[0, 0]
          nil
        end
      end
    end
  end
end
