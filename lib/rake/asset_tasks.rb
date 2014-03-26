require 'rake'
require 'rake/tasklib'
require 'flatrack'
require 'logger'

module Rake
  # helps define asset tasks
  class AssetTasks < Rake::TaskLib
    extend ActiveSupport::Autoload
    autoload :Asset
    autoload :TASKS

    attr_accessor :output
    attr_reader :environment
    attr_reader :index
    attr_reader :manifest
    attr_reader :keep

    delegate :paths, to: :environment

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
      @output       = './public/assets'
      yield self if block_given?
      @index    = environment.index
      @manifest = Sprockets::Manifest.new(index, output)
      @keep     = 2
      define
    end

    def assets
      files.map do |file|
        Asset.new(environment, file).path
      end
    end

    def files
      paths.reduce([]) do |ary, path|
        ary + Dir[File.join path, '**', '*']
      end
    end

    # Define tasks
    def define
      instance_eval(&TASKS)
    end

    private

    # Sub out environment logger with our rake task logger that
    # writes to stderr.
    def with_logger
      env = manifest.environment
      if env
        old_logger = env.logger
        env.logger = @logger
      end
      yield
    ensure
      env.logger = old_logger if env
    end
  end
end
