require 'tilt'
require 'flatrack/template/erubis'
require 'flatrack/template/rb'

class Flatrack
  module Template

    def find(type, file)
      template = find_by_type type, file
      fail FileNotFound, "could not find #{file}" unless template
      Tilt.new template
    rescue RuntimeError
      raise(TemplateNotFound, "could not find a renderer for #{file}")
    end

    private

    def find_by_type(type, file)
      if File.exists?(file)
        file
      else
        Dir[File.join type.to_s.pluralize, "#{file}*"].first
      end
    end

    module_function :find, :find_by_type
  end
end
