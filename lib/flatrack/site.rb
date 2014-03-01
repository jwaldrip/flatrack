require 'rack/server'

module Flatrack
  Site = Rack::Builder.app do

    # Static Assets Should be served directly
    use Rack::Static, urls: ['/favicon.ico', 'assets'], root: 'public'

    Flatrack.middleware.each do |middleware|
      use(*middleware)
    end

    map '/assets' do
      run Flatrack.assets
    end

    map '/' do
      run ->(env) { Request.new(env).response }
    end
  end
end
