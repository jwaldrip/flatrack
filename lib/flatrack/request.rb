module Flatrack
  class Request
    DEFAULT_FORMAT = 'html'

    attr_reader :env, :rack_request

    def initialize(env)
      @rack_request = Rack::Request.new(env)
      @env          = env
    end

    def path
      env['REQUEST_PATH']
    end

    def headers
      env.reduce({}) do |hash, (key, value)|
        next hash unless /^HTTP_(?<name>.+)/ =~ key
        hash.merge name.downcase.to_sym => value
      end
    end

    def params
      rack_request.params.with_indifferent_access
    end

    def format
      (ext = File.extname path).empty? ? DEFAULT_FORMAT : ext.sub(/\./, '')
    end

    def response
      Response.new(self).render
    rescue RendererNotFound
      respond_with_error(500)
    rescue FileNotFound
      respond_with_error(404)
    end

    private

    def respond_with_error(code)
      Response.new(self).render(file: "#{code}.html", status: code)
    rescue FileNotFound
      Response.new(self).render(text: code, status: code)
    end
  end
end
