require 'thor'

module Flatrack
  class CLI < Thor
    include FileUtils
    include Thor::Actions

    desc 'new NAME', 'create a new flatrack site with the given name'

    source_root 'templates'

    def new(name)
      @name = name.titleize
      mkdir_p name
      path                  = File.expand_path name
      self.destination_root = path
      template '.gitignore', '.gitignore'
      template 'Gemfile.erb', 'Gemfile'
      template 'layout.html.erb', 'layouts/layout.html.erb'
      template 'page.html.erb', 'pages/index.html.erb'
      template 'stylesheet.css.scss', 'assets/stylesheet.css.scss'

      Dir.chdir(path) do
        system 'bundle install'
      end
    end

  end
end