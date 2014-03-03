require 'spec_helper'

describe Flatrack::Renderer::Html do
  include SiteHelper

  let(:template) do
    <<-HTML
<body>Hello World</body>
    HTML
  end

  it 'should render properly' do
    sha = SecureRandom.hex
    site do
      write_page("#{sha}.html.html", template)
      status, headers, body = get_page_response(sha)
      expect(body.first).to include template
    end
  end

end
