require 'flatrack/version'
require 'active_support/all'
require 'sprockets'
require 'sprockets-sass'
require 'sass'
require 'rack'

module Flatrack
  extend ActiveSupport::Autoload

  autoload :Renderer
  autoload :Request
  autoload :Response
  autoload :Site
  autoload :AssetExtensions
  autoload :CLI

  RendererNotFound = Class.new StandardError
  FileNotFound     = Class.new StandardError

  FORMATS = {}

  def self.gem_root
    File.expand_path File.join __FILE__, '..'
  end

  def self.site_root
    File.expand_path Dir.pwd
  end

  def self.config(&block)
    yield self
  end

  protected

  def self.assets
    @assets ||= begin
      Sprockets::Environment.new.tap do |environment|
        environment.append_path 'assets/images'
        environment.append_path 'assets/javascripts'
        environment.append_path 'assets/stylesheets'
        environment.context_class.class_eval { include AssetExtensions }
      end
    end
  end

  def self.register_format(ext, mime)
    FORMATS[ext.to_s] = mime
  end

  def self.middleware
    @middleware ||= []
  end

  def self.use(*args)
    self.middleware << args
  end

  # By default we know how to render 'text/html'
  register_format :html, 'text/html'

  # Fix Locales issue
  I18n.enforce_available_locales = false

  # Load all renderers
  Dir.glob(File.expand_path File.join __FILE__, '../../renderers/**/*.rb').each { |f| require f }

end
