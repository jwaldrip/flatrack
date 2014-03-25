class Flatrack
  module FixtureHelper
    extend FileUtils
    include FileUtils

    def render_template(fixture)
      path = File.join Flatrack.gem_root, '../spec/fixtures/templates', fixture
      view.render(path).lines.map(&:strip).join
    end

    private

    def response
      Flatrack::Response.new request
    end

    def request
      Flatrack::Request.new env
    end

    def view
      Flatrack::View.new response
    end

    def env
      Rack::MockRequest.env_for 'http://example.org/index.html'
    end

  end
end