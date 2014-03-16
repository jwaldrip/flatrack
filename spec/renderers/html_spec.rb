require 'spec_helper'

describe 'html' do
  include Flatrack::SiteHelper

  let(:template) do
    <<-HTML
<body>Hello World</body>
    HTML
  end

  it 'should render properly' do
    sha = SecureRandom.hex
    site do
      write(:page, "#{sha}.html", template)
      status, headers, body = get_page_response(sha)
      expect(body.first).to include template
    end
  end

end
