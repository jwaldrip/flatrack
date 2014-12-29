require 'flatrack/version'
require 'active_support/all'
require 'custom-extensions/sprockets-sass'
require 'coffee-script'
require 'sass'
require 'rack'
require 'rack/contrib'

# A static site generator with a little sprinkle of ruby magic
class Flatrack
  extend ActiveSupport::Autoload

  autoload :View
  autoload :Template
  autoload :Request
  autoload :Response
  autoload :Site
  autoload :AssetExtensions
  autoload :CLI
  autoload :Middleware

  # @private
  TemplateNotFound = Class.new StandardError
  # @private
  FileNotFound     = Class.new StandardError
  # @private
  FORMATS          = {}
  # @private
  MAPPING          = { '/assets' => :assets, '/' => :site }

  delegate :gem_root, to: self
  delegate :call, to: :builder
  attr_writer :site_root
  attr_accessor :raise_errors

  class << self
    # The root of the flatrack gem
    # @!attribute [r] gem_root
    # @return [String]
    def gem_root
      File.expand_path File.join __FILE__, '..'
    end

    # The site root
    # @!attribute [r] site_root
    # @return [String]
    def site_root
      Dir.pwd
    end

    # Reset the state of flatrack and its configuration
    def reset!
      @delegate_instance = nil
    end

    private

    def delegate_instance
      @delegate_instance ||= new
    end

    def method_missing(m, *args, &block)
      delegate_instance.public_method(m).call(*args, &block)
    end
  end

  # Configure the flatrack instance
  # @yield [Flatrack] configuration for the flatrack instance
  # @return [Flatrack]
  def config
    yield self if block_given?
    OpenStruct.new(
        site_root:    site_root,
        raise_errors: raise_errors
    ).freeze
  end

  # The flatrack sprockets environment
  # @!attribute [r] assets
  # @return [Sprockets::Environment]
  def assets
    @assets ||= begin
      Sass.load_paths << File.join(site_root, 'assets/stylesheets')
      Sprockets::Environment.new.tap do |environment|
        environment.register_engine '.sass', Sprockets::Sass::SassTemplate
        environment.register_engine '.scss', Sprockets::Sass::ScssTemplate
        environment.append_path File.join site_root, 'assets/images'
        environment.append_path File.join site_root, 'assets/javascripts'
        environment.append_path File.join site_root, 'assets/stylesheets'
        environment.context_class.class_eval { include AssetExtensions }
      end
    end
  end

  # register a format extension by its mime type
  # @param ext [String] the extension
  # @param mime [String] the mime type
  def register_format(ext, mime)
    FORMATS[ext.to_s] = mime
  end

  # The middleware stack for flatrack
  def middleware
    @middleware ||= []
  end

  def mock_env_for(url, opts={})
    env = Rack::MockRequest.env_for url, opts
    env.merge! env_extensions env
  end

  # Insert a rack middleware at the end of the stack
  # @param middleware [Class] the middleware class
  # @param options [Hash] the options for the middleware
  def use(middleware, options = nil)
    self.middleware << [middleware, options].compact
  end

  def site_root
    @site_root || self.class.site_root
  end

  def site
    lambda { |env|
      env.merge! env_extensions env
      Request.new(env).response
    }
  end

  private

  def env_extensions(env)
    # Extract Mount Path
    mount_path =
        env.values_at('ORIGINAL_FULLPATH', 'PATH_INFO')
            .map { |p| p.to_s.split '/' }
            .reduce(:-)
            .join '/'

    # Build Hash
    {
        'flatrack.config'     => self.config,
        'flatrack.mount_path' => mount_path
    }
  end

  def builder
    @builder ||= begin
      this = self
      Rack::Builder.app do
        use Rack::Cookies
        use Rack::Static, urls: ['/favicon.ico', 'assets'], root: 'public'
        this.middleware.each { |mw| use *mw }
        MAPPING.each { |path, app| map(path) { run this.send(app) } }
      end
    end
  end

  # By default we know how to render 'text/html'
  register_format :html, 'text/html'

  # Fix Locales issue
  I18n.enforce_available_locales = false
end
