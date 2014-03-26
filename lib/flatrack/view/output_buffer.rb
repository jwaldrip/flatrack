class Flatrack
  class View
    # A modified output buffer for block evaluation
    class OutputBuffer < ActiveSupport::SafeBuffer #:nodoc:
      # Initializes and encodes the buffer
      def initialize(*)
        super
        encode!
      end

      # appends text to the buffer
      # @param value [String] the value to be appended
      # @return [OutputBuffer]
      def <<(value)
        return self if value.nil?
        super(value.to_s)
      end

      alias_method :append=, :<<

      # safely concatenates value to the buffer
      # @param value [String] the value to be concatenated
      # @return [OutputBuffer]
      def safe_concat(value)
        return self if value.nil?
        super(value.to_s)
      end

      alias_method :safe_append=, :safe_concat
    end
  end
end
