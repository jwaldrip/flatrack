require 'flatrack/version'
require 'active_support/all'
require 'sprockets'
require 'sprockets-sass'
require 'sass'
require 'rack'

class Flatrack
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

  delegate :gem_root, :site_root, to: self

  def self.gem_root
    File.expand_path File.join __FILE__, '..'
  end

  def self.site_root
    File.expand_path Dir.pwd
  end

  class << self

    def delegate_instance
      @delegate_instance ||= new
    end

    def reset!
      @delegate_instance = nil
    end

    private

    def method_missing(m, *args, &block)
      delegate_instance.public_method(m).call(*args, &block)
    end

  end

  def config(&block)
    yield self
  end

  def assets
    @assets ||= begin
      Sprockets::Environment.new.tap do |environment|
        environment.append_path 'assets/images'
        environment.append_path 'assets/javascripts'
        environment.append_path 'assets/stylesheets'
        environment.context_class.class_eval { include AssetExtensions }
      end
    end
  end

  def register_format(ext, mime)
    FORMATS[ext.to_s] = mime
  end

  def middleware
    @middleware ||= []
  end

  def use(*args)
    middleware << args
  end

  # By default we know how to render 'text/html'
  register_format :html, 'text/html'

  # Fix Locales issue
  I18n.enforce_available_locales = false

  # Load all renderers
  Dir.glob(File.join gem_root, '../renderers/**/*.rb').each do |f|
    require f
  end
end
