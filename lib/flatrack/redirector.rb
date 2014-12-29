class Flatrack
  def Redirector(source, opts={})
    to    = opts.delete(:to)
    type  = opts.delete(:type) || :permanent
    klass = Class.new(Redirector)
    klass.send(:define_method, :initialize) do |app, mw_opts|
      mapping = { source => Redirector::Redirect.new(to, type) }
      super app, mapping, mw_opts
    end
    klass
  end

  class Redirector

    def initialize(app, mapping = {}, opts = {})
      @if      = opts[:if] || Proc.new { true }
      @unless  = opts[:unless] || Proc.new { false }
      @app     = app
      @mapping =
        Hash[mapping.map { |k, v| [File.join('', k), v] }]
    end

    def call(env)
      allow = @if.call(env) && !@unless.call(env)
      if allow && @mapping.keys.include?(env['PATH_INFO'])
        @mapping[env['PATH_INFO']].response
      else
        @app.call env
      end
    end

    private

    class Redirect

      attr_reader :url, :type

      def initialize(url, type = :permanent)
        @url, @type = url, type
        code # just to check args
      end

      # Returns the code for the specified type
      # @returns [Fixnum]
      def code
        case type.to_sym
        when :permanent
          301
        when :temporary
          302
        else
          raise ArgumentError, 'type must be :temporary or :permanent'
        end
      end

      def response
        [code, { 'location' => url }, ["you are being redirected to: `#{url}`"]]
      end

    end

  end
end