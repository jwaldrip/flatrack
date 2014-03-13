require 'spec_helper'

describe 'erb' do
  include Flatrack::SiteHelper

  let(:template) do
  <<-ERB
<%= 'Hello World'.reverse %>
  ERB
  end

  it 'should render properly' do
    sha = SecureRandom.hex
    site do
      write(:page, "#{sha}.html.erb", template)
      status, headers, body = get_page_response(sha)
      expect(body.first).to include 'Hello World'.reverse
    end
  end

end
