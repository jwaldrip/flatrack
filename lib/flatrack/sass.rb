require 'sass'

class Flatrack
  module Sass
    extend ActiveSupport::Autoload

    autoload :SassTemplate
    autoload :ScssTemplate
    autoload :Importer

  end
end
