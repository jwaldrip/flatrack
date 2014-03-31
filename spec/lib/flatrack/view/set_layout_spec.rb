require 'spec_helper'

describe Flatrack::View do
  def render_template(fixture)
    path = File.join Flatrack.gem_root, '../spec/fixtures/templates', fixture
    env = Rack::MockRequest.env_for 'http://example.com'
    req = Flatrack::Request.new env
    _, _, body = Flatrack::Response.new(req).render(file: path)
    body.first.lines.map(&:strip).join
  end

  describe '#link_to' do

    context 'using erb' do
      it 'should properly render' do
        template_content = render_template 'set_layout.html.erb'
        expected_content = render_template 'set_layout.html'
        expect(template_content).to eq expected_content
      end
    end

    context 'using rb' do
      it 'should properly render' do
        template_content = render_template 'set_layout.html.rb'
        expected_content = render_template 'set_layout.html'
        expect(template_content).to eq expected_content
      end
    end

  end
end
