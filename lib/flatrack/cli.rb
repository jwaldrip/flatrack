require 'thor'
require 'flatrack'

module Flatrack
  class CLI < Thor
    include FileUtils
    include Thor::Actions

    desc 'new NAME', 'create a new flatrack site with the given name'

    source_root File.join Flatrack.gem_root, '..', 'templates'

    def new(name)
      @name = name.titleize
      mkdir_p name
      path                  = File.expand_path name
      self.destination_root = path
      template '.gitignore', '.gitignore'
      template 'boot.rb', 'boot.rb'
      template 'Rakefile', 'Rakefile'
      template 'Gemfile.erb', 'Gemfile'
      template 'config.ru', 'config.ru'
      template 'layout.html.erb', 'layouts/layout.html.erb'
      template 'page.html.erb', 'pages/index.html.erb'
      template 'stylesheet.css.scss', 'assets/stylesheet.css.scss'

      Dir.chdir(path) do
        system 'bundle install'
      end
    end

    desc 'start PORT', 'run the site on the given port'

    def start(port=5959)
      require './boot'
      Rack::Server.start app: Flatrack::Site, Port: port
    end

  end
end