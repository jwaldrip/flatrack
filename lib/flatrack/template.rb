require 'tilt'
require 'flatrack/template/erubis'
require 'flatrack/template/rb'
require 'flatrack/template/html'

class Flatrack
  # The default template parser/finder
  class Template
    attr_reader :type, :file

    # Creates a new template instance and invokes find
    # @param type [Symbol] the type of template
    # @param file [String] the location of the file
    def self.find(type, file)
      new(type, file).find
    end

    # Creates a new template instance
    # @param type [Symbol] the type of template
    # @param file [String] the location of the file
    def initialize(type, file)
      @type, @file = type, file
    end

    # Finds a given template
    # @return [Tilt::Template]
    def find
      template = find_by_type
      fail FileNotFound, "could not find #{file}" unless template
      Tilt.new template, options
    rescue RuntimeError
      raise(TemplateNotFound, "could not find a renderer for #{file}")
    end

    private

    def options
      local_options = {}
      super.merge local_options
    rescue NoMethodError
      local_options
    end

    def find_by_type
      if File.exist?(file)
        file
      else
        Dir[File.join type.to_s.pluralize, "#{file}*"].first
      end
    end
  end
end
