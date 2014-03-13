class Flatrack
  class Request
    DEFAULT_FORMAT = 'html'

    attr_reader :env, :rack_request

    def initialize(env)
      @rack_request = Rack::Request.new(env)
      @env          = env
    end

    def path
      env['PATH_INFO']
    end

    def params
      rack_request.params.with_indifferent_access
    end

    def format
      (ext = File.extname path).empty? ? DEFAULT_FORMAT : ext.sub(/\./, '')
    end

    def response
      Response.new(self).render
    rescue TemplateNotFound
      respond_with_error(500)
    rescue FileNotFound
      respond_with_error(404)
    end

    private

    def respond_with_error(code)
      Response.new(self).render(file: "#{code}.html", status: code)
    rescue FileNotFound
      file = File.join Flatrack.gem_root, '../error_pages', "#{code}.html"
      Response.new(self).render(file: file, status: code)
    end
  end
end
