require 'spec_helper'

describe Flatrack::View do
  include Flatrack::SiteHelper

  let(:uri) { URI.parse 'http://example.org/index.html' }
  let(:env) { Rack::MockRequest.env_for uri.to_s }
  let(:request) { Flatrack::Request.new env }
  let(:response) { Flatrack::Response.new request }
  subject(:view) { described_class.new response }

  describe '#initialize' do
    it 'should set the response' do
      view = described_class.allocate
      expect do
        view.send :initialize, response
      end.to change {
        view.instance_variable_get :@response
      }.to response
    end
  end

  describe '#params' do
    let(:uri) { URI.parse 'http://example.org/index.html?foo=bar' }
    it 'should be extracted from the uri path' do
      expect(view.params).to include foo: 'bar'
    end
  end

  describe '#path' do
    it 'should be extracted from the uri path' do
      expect(view.path).to eq uri.path
    end
  end

  describe '#render' do
    let(:template) do
      <<-ERB
<%= 'Hello World'.reverse %>
      ERB
    end

    it 'should properly render a partial' do
      site do
        write(:partial, 'sample.erb', template)
        result = view.render(:sample)
        expect(result).to include 'Hello World'.reverse
      end
    end
  end

end
