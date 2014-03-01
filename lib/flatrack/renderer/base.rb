module Flatrack
  module Renderer
    class Base
      attr_reader :contents

      def self.renders(ext = nil)
        @renders = ext.to_sym
      end

      def self.renders?(ext)
        @renders == ext.to_sym
      end

      def initialize(file)
        @contents = File.read file
      end
    end
  end
end
