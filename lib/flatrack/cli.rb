require 'thor'
require 'flatrack'

module Flatrack
  class CLI < Thor
    include FileUtils
    include Thor::Actions

    source_root File.join Flatrack.gem_root, '..', 'templates'

    desc 'new NAME', 'create a new flatrack site with the given name'

    KEEP_DIRS = [
      'assets/stylesheets',
      'assets/javascripts',
      'assets/images',
      'pages',
      'layouts'
    ]

    FILES = {
      '.gitignore'           => '.gitignore',
      'boot.rb'              => 'boot.rb',
      'Rakefile'             => 'Rakefile',
      'Gemfile.erb'          => 'Gemfile',
      'config.ru'            => 'config.ru',
      'layout.html.erb'      => 'layouts/layout.html.erb',
      'page.html.erb'        => 'pages/index.html.erb',
      'stylesheet.css.scss'  => 'assets/stylesheets/main.css.scss',
      'javascript.js.coffee' => 'assets/javascripts/main.js.coffee'
    }

    def new(path)
      mkdir_p path
      full_path             = File.expand_path path
      @name                 = File.basename(full_path).titleize
      self.destination_root = full_path
      write_keeps
      write_files
      bundle!
    end

    desc 'start PORT', 'run the site on the given port'

    def start(port = 5959)
      require './boot'
      Rack::Server.start app: Flatrack::Site, Port: port
    end

    private

    def bundle!
      Dir.chdir(destination_root) do
        system 'bundle install'
      end
    end

    def write_keeps
      KEEP_DIRS.each do |dir|
        template '.keep', File.join(dir, '.keep')
      end
    end

    def write_files
      FILES.each do |temp, dest|
        template temp, dest
      end
    end
  end
end
