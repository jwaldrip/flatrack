# Rake Extensions
module Rake
  class AssetTasks
    # Asset class for sprockets pre-compilation
    class Asset
      # Returns a sprockets asset
      # @param env [Sprockets::Environment]
      # @param file [String]
      def initialize(env, file)
        @env  = env
        @file = file
      end

      # Returns the path of an asset
      # @return [String]
      def path
        File.expand_path(file).sub(/(#{@env.paths.join('|')})\//, '')
      end

      private

      def basename
        File.basename @file
      end

      def parts
        basename.split('.').size
      end

      def file
        if parts > 2
          @file.split('.').tap(&:pop).join('.')
        else
          @file
        end
      end
    end
  end
end
