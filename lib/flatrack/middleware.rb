class Flatrack
  class Middleware

    def initialize(app, opts = {})
      @if      = opts[:if] || Proc.new { true }
      @unless  = opts[:unless] || Proc.new { false }
      @app          = app
      @flatrack_app = opts[:flatrack_app] || Flatrack::Site
    end

    def call(env)
      Flatrack::DomainParser.new(null_app).call(env)
      allow = @if.call(env) && !@unless.call(env)
      return call_app env unless allow
      response = @flatrack_app.call env
      status, _, _ = response
      response     = call_app(env) if status == 404
      response
    rescue Flatrack::FileNotFound
      call_app env
    end

    def call_app(env)
      @app.call env
    end

    def null_app
      ->(_){}
    end

  end
end
