class Flatrack
  class View
    # A modified output buffer for block evaluation
    class OutputBuffer < ActiveSupport::SafeBuffer #:nodoc:
      def initialize(*)
        super
        encode!
      end

      def <<(value)
        return self if value.nil?
        super(value.to_s)
      end

      alias_method :append=, :<<

      def safe_concat(value)
        return self if value.nil?
        super(value.to_s)
      end

      alias_method :safe_append=, :safe_concat
    end
  end
end
