require 'spec_helper'

describe Flatrack do

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

end
