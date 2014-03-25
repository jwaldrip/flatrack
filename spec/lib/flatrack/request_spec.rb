require 'spec_helper'

describe Flatrack::Request do
  include Flatrack::SiteHelper

  describe '#response' do
    it 'should return a 404 for page not found' do
      site do
        status, headers, body = get_page_response('cant_find_me')
        expect(status).to eq 404
      end
    end

    it 'should render a page without a layout' do
      site do
        touch 'pages/bad_renderer.html.bad'
        status, headers, body = get_page_response('bad_renderer')
        expect(status).to eq 500
      end
    end
  end
end
