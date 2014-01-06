module FlatRack
  App = Rack::Builder.app do
    map '/assets' do
      run FlatRack.assets
    end

    map '/' do
      use Rack::Static, urls: ["/favicon.ico", "assets"], root: "public"
      run ->(env){ Request.new(env).response }
    end
  end
end