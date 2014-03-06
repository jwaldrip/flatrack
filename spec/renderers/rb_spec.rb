require 'spec_helper'

describe Flatrack::Renderer::Rb do
  include SiteHelper

  let(:template) do
    <<-RUBY
'Hello World'.reverse
    RUBY
  end

  it 'should render properly' do
    sha = SecureRandom.hex
    site do
      write(:page, "#{sha}.html.rb", template)
      status, headers, body = get_page_response(sha)
      expect(body.first).to include 'Hello World'.reverse
    end
  end

end
