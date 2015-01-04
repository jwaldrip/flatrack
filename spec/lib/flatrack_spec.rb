require 'spec_helper'

describe Flatrack do
  include Flatrack::SiteHelper

  describe '.gem_root' do
    it 'should be the root of the gem' do
      expect(File.directory? described_class.gem_root).to be true
    end
  end

  describe '.site_root' do
    it 'should be the root of the gem' do
      Dir.chdir('/') do
        expect(File.directory? described_class.site_root).to be true
        expect(described_class.site_root).to eq '/'
      end
    end
  end

  describe '.config' do
    it 'should yield the Flatrack module' do
      described_class.config do |site|
        expect(site).to be_a Flatrack
      end
    end
  end

  describe '.redirect' do
    it 'should redirect requests with a 301' do
      site do
        Flatrack.config do |site|
          site.redirect '/foo', to: '/bar'
        end
        status, headers, _ = get_page_response '/foo'
        expect(status).to eq 301
        expect(headers['location']).to eq '/bar'
      end
    end

    context 'when an argument is not a string' do
      it 'should raise an error' do
        Flatrack.config do |site|
          expect { site.redirect :bar, to: '/' }
            .to raise_error ArgumentError
        end
      end
    end

    context 'with type :permanent' do
      it 'should redirect requests with a 301' do
        site do
          Flatrack.config do |site|
            site.redirect '/foo', to: '/bar', type: :permanent
          end
          status, headers, _ = get_page_response '/foo'
          expect(status).to eq 301
          expect(headers['location']).to eq '/bar'
        end
      end
    end

    context 'with type :temporary' do
      it 'should redirect requests with a 302' do
        site do
          Flatrack.config do |site|
            site.redirect '/foo', to: '/bar', type: :temporary
          end
          status, headers, _ = get_page_response '/foo'
          expect(status).to eq 302
          expect(headers['location']).to eq '/bar'
        end
      end
    end
  end

  describe '.rewrite' do
    it 'should rewrite a path' do
      site do
        write :page, 'bar.html.rb', '"page is #{current_page}"'
        Flatrack.config do |site|
          site.raise_errors = true
          site.rewrite '/foo', to: '/bar.html'
        end
        status, _, body = get_page_response '/foo'
        expect(status).to eq 200
        expect(body.body.first).to include 'page is /bar.html'
      end
    end

    context 'when an argument is not a string' do
      it 'should raise an error' do
        Flatrack.config do |site|
          expect { site.rewrite :bar, to: '/' }
            .to raise_error ArgumentError
        end
      end
    end
  end

end
