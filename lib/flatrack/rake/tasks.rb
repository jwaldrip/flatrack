require 'rake'
require 'flatrack'
require 'rake/asset_tasks'

Rake::AssetTasks.new do |t|
  t.environment = Flatrack.assets
  t.output      = "./public/assets"
  t.assets      = %w( application.js application.css )
end