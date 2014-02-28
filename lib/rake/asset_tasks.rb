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
      @environment  = Flatrack.assets
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
        parts         = file_basename.split('.').size
        file          = file.split('.').tap(&:pop).join('.') if parts > 2
        File.expand_path(file).sub(/(#{environment.paths.join('|')})\//, '')
      end
    end

    # Define tasks
    def define
      file = File.expand_path File.join __FILE__, '../assets.rake'
      eval File.read file
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