require 'spec_helper'

describe Flatrack::Response do
  include SiteHelper

  describe 'render' do
    it 'should render a page with a layout' do
      site do
        status, headers, body = get_page_response('index')
        expect(status).to eq 200
      end
    end

    it 'should render a page without a layout' do
      site do
        rm_rf 'layouts/layout.html.erb'
        status, headers, body = get_page_response('index')
        expect(status).to eq 200
      end
    end
  end
end