require 'spec_helper'

describe Flatrack::Renderer::ERB do
  include SiteHelper

  let(:template) do
  <<-ERB
<%= 'Hello World'.reverse %>
  ERB
  end

  it 'should render properly' do
    sha = SecureRandom.hex
    site do
      write_page("#{sha}.html.erb", template)
      status, headers, body = get_page_response(sha)
      expect(body.first).to include 'Hello World'.reverse
    end
  end

end
