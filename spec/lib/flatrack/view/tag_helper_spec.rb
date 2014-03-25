require 'spec_helper'

describe Flatrack::View::TagHelper do
  include Flatrack::FixtureHelper

  describe '#html_tag' do
    let(:expected) { render_template 'html_tag.html' }

    context 'using erb' do
      it 'should properly render' do
        template_content = render_template 'html_tag.html.erb'
        expect(template_content).to eq expected
      end
    end

    context 'using rb' do
      it 'should properly render' do
        template_content = render_template 'html_tag.html.rb'
        expect(template_content).to eq expected
      end
    end

  end

  describe '#image_tag' do
    let(:expected) { render_template 'image_tag.html' }

    context 'using erb' do
      it 'should properly render' do
        template_content = render_template 'image_tag.html.erb'
        expect(template_content).to eq expected
      end
    end

    context 'using rb' do
      it 'should properly render' do
        template_content = render_template 'image_tag.html.rb'
        expect(template_content).to eq expected
      end
    end

  end

  describe '#javascript_tag' do
    let(:expected) { render_template 'javascript_tag.html' }

    context 'using erb' do
      it 'should properly render' do
        template_content = render_template 'javascript_tag.html.erb'
        expect(template_content).to eq expected
      end
    end

    context 'using rb' do
      it 'should properly render' do
        template_content = render_template 'javascript_tag.html.rb'
        expect(template_content).to eq expected
      end
    end

  end

  describe '#stylesheet_tag' do
    let(:expected) { render_template 'stylesheet_tag.html' }

    context 'using erb' do
      it 'should properly render' do
        template_content = render_template 'stylesheet_tag.html.erb'
        expect(template_content).to eq expected
      end
    end

    context 'using rb' do
      it 'should properly render' do
        template_content = render_template 'stylesheet_tag.html.rb'
        expect(template_content).to eq expected
      end
    end

  end
end
