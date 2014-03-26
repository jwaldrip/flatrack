require 'rack/server'

class Flatrack
  # Provides a rake wrapper for encapsulating a flatrack site
  module Site
    # Call the site with a rack env
    # @param env [Hash] the rack env
    def self.call(env)
      builder.call(env)
    end

    private

    def self.builder
      mapping = self.mapping
      Rack::Builder.app do
        use Rack::Static, urls: ['/favicon.ico', 'assets'], root: 'public'
        Flatrack.middleware.each { |mw| use(*mw) }
        mapping.each { |path, app| map(path) { run app } }
      end
    end

    def self.site
      ->(env) { Request.new(env).response }
    end

    def self.mapping
      {
        '/assets' => Flatrack.assets,
        '/'       => site
      }
    end
  end
end
