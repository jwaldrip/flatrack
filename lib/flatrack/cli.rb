require 'thor'
require 'flatrack'

module Flatrack
  class CLI < Thor
    include FileUtils
    include Thor::Actions

    source_root File.join Flatrack.gem_root, '..', 'templates'

    desc 'new NAME', 'create a new flatrack site with the given name'

    def new(name)
      @name = name.titleize
      mkdir_p name
      path                  = File.expand_path name
      self.destination_root = path

      # Store keep files
      template '.keep', 'assets/stylesheets/.keep'
      template '.keep', 'assets/javascripts/.keep'
      template '.keep', 'assets/images/.keep'
      template '.keep', 'pages/.keep'
      template '.keep', 'layouts/.keep'

      # Write from templates
      template '.gitignore', '.gitignore'
      template 'boot.rb', 'boot.rb'
      template 'Rakefile', 'Rakefile'
      template 'Gemfile.erb', 'Gemfile'
      template 'config.ru', 'config.ru'
      template 'layout.html.erb', 'layouts/layout.html.erb'
      template 'page.html.erb', 'pages/index.html.erb'
      template 'stylesheet.css.scss', 'assets/stylesheets/main.css.scss'
      template 'javascript.js.coffee', 'assets/javascripts/main.js.coffee'

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