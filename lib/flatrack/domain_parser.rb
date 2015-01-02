class Flatrack
  class DomainParser < Struct.new :app

    def call(env)
      *subdomains, host, tld = env['SERVER_NAME'].split '.'
      env['domain.sub']      = subdomains.join '.'
      env['domain.host']     = host
      env['domain.tld']      = tld
      app.call(env)
    end

  end
end
