require 'spec_helper'

describe Flatrack::View do
  include Flatrack::SiteHelper

  let(:uri) { URI.parse 'http://example.org/index.html' }
  let(:env){ Rack::MockRequest.env_for uri.to_s }
  let(:request){ Flatrack::Request.new env }
  let(:response){ Flatrack::Response.new request }
  subject(:view){ described_class.new response }

  describe '#initialize' do
    it 'should set the response' do
      view = described_class.allocate
      expect {
        view.send :initialize, response
      }.to change {
        view.instance_variable_get :@response
      }.to response
    end
  end

  describe '#get_binding' do
    it 'should yield to the view' do
      view.get_binding do
        expect(self.class).to be_a described_class
      end
    end
  end

  describe '#image_tag' do
    it 'should be a proper image tag' do
      expect(view.image_tag 'test.png')
      .to eq "<img src=\"/assets/test.png\"/>"
    end
  end

  describe '#javascript_tag' do
    it 'should be a proper javascript tag' do
      expect(view.javascript_tag :test)
      .to eq "<script src=\"/assets/test.js\"></script>"
    end
  end

  describe '#link_to' do
    it 'should be a proper link tag with a name' do
      expect(view.link_to 'test', '/test.html', params: { foo: 'bar' }, class: 'test')
      .to eq "<a class=\"test\" href=\"/test.html?foo=bar\">test</a>"
    end

    it 'should be a proper link tag without a name' do
      expect(view.link_to '/test.html', params: { foo: 'bar' }, class: 'test')
      .to eq "<a class=\"test\" href=\"/test.html?foo=bar\">/test.html?foo=bar</a>"
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

  describe '#stylesheet_tag' do
    it 'should be a proper stylesheet tag' do
      expect(view.stylesheet_tag :test)
      .to eq "<link href=\"/assets/test.css\" rel=\"stylesheet\" type=\"text/css\"/>"
    end
  end

end