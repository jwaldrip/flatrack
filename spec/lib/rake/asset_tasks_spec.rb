require 'spec_helper'
require 'rake/asset_tasks'
require 'coffee-script'

describe Rake::AssetTasks do
  include FileUtils

  before(:all) do
    @rake            = Rake::Application.new
    Rake.application = @rake

    @env = Sprockets::Environment.new(".") do |env|
      env.append_path File.join Flatrack.gem_root, '../spec/fixtures/assets'
    end

    @dir = File.join(Dir::tmpdir, 'sprockets/manifest')

    @manifest = Sprockets::Manifest.new(@env, @dir)

    Rake::AssetTasks.new do |t|
      t.environment = @env
      t.output      = @dir
      t.log_level   = :fatal
    end
  end

  after(:all) do
    Rake.application = nil
    rm_rf(@dir)
    expect(Dir["#{@dir}/*"]).to be_empty
  end

  it "should precompile" do
    digest_path = @env['application.js'].digest_path
    expect(File.exist? "#{@dir}/#{digest_path}").to be false

    @rake['assets:precompile'].invoke

    expect(Dir["#{@dir}/manifest-*.json"]).to be_present
    expect(File.exist? "#{@dir}/#{digest_path}").to be true
  end

  it "should clobber" do
    digest_path = @env['application.js'].digest_path

    @rake['assets:precompile'].invoke
    expect(File.exist? "#{@dir}/#{digest_path}").to be true

    @rake['assets:clobber'].invoke
    expect(File.exist? "#{@dir}/#{digest_path}").to be false
  end

  xit "should clean" do
  end
end