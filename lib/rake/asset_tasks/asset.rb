module Rake
  class AssetTasks::Asset
    def initialize(env, file)
      @env  = env
      @file = file
    end

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
