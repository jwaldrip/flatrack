module Flatrack

  register_format :html, 'text/html'

  Site = Rack::Builder.app do
    map '/assets' do
      run Flatrack.assets
    end

    map '/' do
      use Rack::Static, urls: ["/favicon.ico", "assets"], root: "public"
      run ->(env){ Request.new(env).response }
    end
  end
end