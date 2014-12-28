class Flatrack
  # parses an incoming flatrack request and provides a method to render a
  # response
  class Request
    attr_reader :env, :rack_request

    # Initializes a response
    # @param env [Hash] the rack env
    def initialize(env)
      @rack_request = Rack::Request.new(env)
      @env          = env
    end

    # the path of the incoming request
    def path
      env['PATH_INFO']
    end

    # the params on the incoming request
    def params
      rack_request.params.with_indifferent_access
    end

    # the format on the incoming request
    def format
      ext = File.extname path
      unless ext.empty?
        path.sub!(/#{ext}/, '')
        ext.split('.').last
      end
    end

    # the processed response for an inbound request
    def response
      Response.new(self).render
    rescue TemplateNotFound => e
      raise e if config.raise_errors
      respond_with_error(500)
    rescue FileNotFound => e
      raise e if config.raise_errors
      respond_with_error(404)
    end

    def config
      env['flatrack.config']
    end

    def mount_path
      env['flatrack.mount_path']
    end

    private

    def respond_with_error(code)
      Response.new(self).render(file: code, status: code)
    rescue FileNotFound
      file = File.join Flatrack.gem_root, '../error_pages', "#{code}.html"
      Response.new(self).render(file: file, status: code)
    end
  end
end
