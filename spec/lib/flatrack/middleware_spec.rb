require 'spec_helper'

describe Flatrack::Middleware do
  include Flatrack::SiteHelper

  def request(path)
    url      = URI.parse 'http://example.com'
    url.path = File.join '/', path
    env      = Rack::MockRequest.env_for url.to_s
    middleware.call env
  end

  let(:flatrack_app) { Flatrack::Site }
  let(:app) { ->(_) { [200, {}, ['OK']] } }
  let(:middleware) { described_class.new app, flatrack_app: flatrack_app }

  context 'given a status of 404' do
    it 'should call the original app' do
      site do
        expect(app).to receive(:call)
        request '/nothing_here'
      end
    end
  end

  context 'when a NotFound error is raised' do
    it 'should call the original app' do
      site do
        Flatrack.config { |site| site.raise_errors = true }
        expect(app).to receive(:call)
        request '/nothing_here'
      end
    end
  end

  context 'when the response is 200' do
    it 'should not call the original app' do
      site do
        expect(app).to_not receive(:call)
        request '/'
      end
    end
  end

  context 'when the response is 500' do
    it 'should not call the original app' do
      site do
        write :page, 'bad_render.html.ggr', ''
        expect(app).to_not receive(:call)
        request '/bad_render'
      end
    end
  end

end
