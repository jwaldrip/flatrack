require 'spec_helper'

describe Flatrack::View::LinkHelper do
  include Flatrack::FixtureHelper

  describe '#link_to' do

    context 'using erb' do
      it 'should properly render' do
        template_content = render_template 'link_to.html.erb'
        expected_content = render_template 'link_to.html'
        expect(template_content).to eq expected_content
      end
    end

    context 'using rb' do
      it 'should properly render' do
        template_content = render_template 'link_to.html.rb'
        expected_content = render_template 'link_to.html'
        expect(template_content).to eq expected_content
      end
    end

  end
end