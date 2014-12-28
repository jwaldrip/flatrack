class Flatrack
  class Middleware

    def initialize(app, flatrack_app: Flatrack::Site)
      @app          = app
      @flatrack_app = flatrack_app
    end

    def call(env)
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

  end
end