require 'tilt'
require 'flatrack/template/erubis'
require 'flatrack/template/rb'
require 'flatrack/template/html'

class Flatrack
  # The default template parser/finder
  class Template
    # @private
    DEFAULT_FORMAT = 'html'

    attr_reader :base_path, :type, :file, :format
    delegate :render, to: :@renderer

    def self.register_path(path)
      classes.each do |klass|
        files = Dir.glob File.join path, '**', "*.#{klass::RENDERS}"
        Tilt.register klass, *files
      end
    end

    # Creates a new template instance and invokes find
    # @param type [Symbol] the type of template
    # @param format [String] the format e.g. html
    # @param file [String] the location of the file
    def self.find(base_path, type, format, file)
      new(base_path, type, format, file)
    end

    # Creates a new template instance
    # @param type [Symbol] the type of template
    # @param format [String] the format e.g. html
    # @param file [String] the location of the file
    def initialize(base_path, type, format, file)
      @base_path   = base_path
      @format      = format || DEFAULT_FORMAT
      @type, @file = type, file.to_s
      @renderer    = find
    end

    private

    def self.classes
      constants.map { |k| const_get k }.select do |klass|
        klass.is_a?(Class) && klass < Tilt::Template
      end
    end

    def find
      template = find_by_type
      fail FileNotFound, "could not find #{file}" unless template
      template = File.expand_path template
      Tilt.new template, options
    rescue RuntimeError
      raise TemplateNotFound, "could not find a renderer for #{file}"
    end

    def options
      local_options = {}
      super.merge local_options
    rescue NoMethodError
      local_options
    end

    def find_by_type
      paths = [base_path, Flatrack.gem_root]
      if paths.any? { |path| file.start_with? path } && File.exist?(file)
        file
      else
        file_with_format = [file, format].compact.join('.')
        Dir[File.join base_path, type.to_s.pluralize, "#{file_with_format}*"].first
      end
    end
  end
end
