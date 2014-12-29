class Flatrack
  def Rewriter(source, opts={})
    to    = opts.delete(:to)
    klass = Class.new(Rewriter)
    klass.send(:define_method, :initialize) do |app, mw_opts|
      mapping = { source => to }
      super app, mapping, mw_opts
    end
    klass
  end

  class Rewriter

    def initialize(app, mapping = {}, opts = {})
      @if      = opts[:if] || Proc.new { true }
      @unless  = opts[:unless] || Proc.new { false }
      @app     = app
      @mapping =
        Hash[mapping.map { |paths| paths.map { |p| File.join '', p } }]
    end

    def call(env)
      allow = @if.call(env) && !@unless.call(env)
      if allow && @mapping.keys.include?(env['PATH_INFO'])
        env['ORIGINAL_PATH_INFO'] = env['PATH_INFO']
        env['PATH_INFO']          = @mapping[env['PATH_INFO']]
      end
      @app.call env
    end

  end
end