# The tasks defined for pre-compilation of assets
Rake::AssetTasks::TASKS = proc do
  namespace :assets do
    desc 'precompile assets'
    task :precompile do
      with_logger do
        manifest.compile(assets)
      end
    end

    desc 'Remove all assets'
    task :clobber do
      with_logger do
        manifest.clobber
      end
    end

    desc 'Clean old assets'
    task :clean do
      with_logger do
        manifest.clean(keep)
      end
    end
  end
end
