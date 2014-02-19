require 'flatrack/version'
require 'sprockets'
require 'active_support/all'

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

  def self.root
    File.expand_path File.join __FILE__, '..'
  end

  def self.register_format(ext, mime)
    FORMATS[ext.to_s] = mime
  end

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

  I18n.enforce_available_locales = false

  Dir.glob(File.expand_path File.join __FILE__, '../../renderers/**/*.rb').each { |f| require f }

end
