require 'rake'
require 'rake/tasklib'
require 'flatrack'
require 'logger'

module Rake
  # Simple Sprockets compilation Rake task macro.
  #
  #   Rake::AssetTasks.new
  #
  class AssetTasks < Rake::TaskLib

    attr_reader :environment
    attr_reader :index
    attr_reader :manifest
    attr_reader :output
    attr_reader :keep

    # Number of old assets to keep.

    # Logger to use during rake tasks. Defaults to using stderr.
    #
    #   t.logger = Logger.new($stdout)
    #
    attr_accessor :logger

    # Returns logger level Integer.
    def log_level
      @logger.level
    end

    # Set logger level with constant or symbol.
    #
    #   t.log_level = Logger::INFO
    #   t.log_level = :debug
    #
    def log_level=(level)
      if level.is_a?(Integer)
        @logger.level = level
      else
        @logger.level = Logger.const_get(level.to_s.upcase)
      end
    end

    def initialize
      @environment  = FlatRack.assets
      @logger       = Logger.new($stderr)
      @logger.level = Logger::INFO
      @index        = environment.index
      @output       = "./public/assets"
      @manifest     = Sprockets::Manifest.new(index, output)
      @keep         = 2
      define
    end

    def assets
      Dir['assets/**/*.*'].map do |file|
        file_basename = File.basename file
        file = file.split('.').tap(&:pop).join('.') if file_basename.split('.').size > 2
        File.expand_path(file).sub(/(#{environment.paths.join('|')})\//,'')
      end
    end

    # Define tasks
    def define
      namespace :assets do
        desc 'precompile assets'
        task :precompile do
          with_logger do
            manifest.compile(assets)
          end
        end

        desc "Remove all assets"
        task :clobber do
          with_logger do
            manifest.clobber
          end
        end

        desc "Clean old assets"
        task :clean do
          with_logger do
            manifest.clean(keep)
          end
        end

      end
    end

    private

    # Sub out environment logger with our rake task logger that
    # writes to stderr.
    def with_logger
      if env = manifest.environment
        old_logger = env.logger
        env.logger = @logger
      end
      yield
    ensure
      env.logger = old_logger if env
    end

  end
end