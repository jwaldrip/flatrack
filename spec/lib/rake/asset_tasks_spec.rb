require 'spec_helper'
require 'flatrack'
require 'rake/asset_tasks'

describe Rake::AssetTasks do
  include FileUtils
  include Flatrack::SiteHelper

  before(:each) do
    @sha = site(clean: false) do
      @rake            = Rake::Application.new
      Rake.application = @rake

      @env = Flatrack.assets
      @dir = File.join(Dir.tmpdir, 'sprockets/manifest')

      Rake::AssetTasks.new do |t|
        t.output    = @dir
        t.log_level = :fatal
      end
    end
  end

  after(:each) do
    Rake.application = nil
    cleanup(@sha)
    rm_rf(@dir)
    expect(Dir["#{@dir}/*"]).to be_empty
  end

  describe '#log_level=' do
    it 'should set the proper log level' do
      @sha = site(clean: false) do
        allow_any_instance_of(Rake::AssetTasks).to receive(:define)
        tasks = Rake::AssetTasks.new do |t|
          t.output    = @dir
          t.log_level = 1
        end
        expect(tasks.log_level).to eq 1
      end
    end
  end

  describe 'tasks' do

    it 'should precompile' do
      digest_path = @env['main.js'].digest_path
      expect(File.exist? "#{@dir}/#{digest_path}").to be false

      @rake['assets:precompile'].invoke

      expect(Dir["#{@dir}/manifest-*.json"]).to be_present
      expect(File.exist? "#{@dir}/#{digest_path}").to be true
    end

    it 'should clobber' do
      digest_path = @env['main.js'].digest_path

      @rake['assets:precompile'].invoke
      expect(File.exist? "#{@dir}/#{digest_path}").to be true

      @rake['assets:clobber'].invoke
      expect(File.exist? "#{@dir}/#{digest_path}").to be false
    end

    it 'should clean' do
      expect do
        @rake['assets:clean'].invoke
      end.to_not raise_error
    end

  end
end
