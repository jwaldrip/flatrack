class Flatrack
  # Handles flatrack responses
  class Response
    # @private
    DEFAULT_FILE = 'index'

    attr_reader :request

    # Initializes a response
    # @param request [Flatrack::Request]
    def initialize(request)
      @request = request
    end

    # Renders a response
    # @param opts [Hash]
    # @option opts [String] :file
    # @option opts [Fixnum] :status
    # @option opts [Symbol] :layout
    # @return [Array] the rack response
    def render(file: file_for(request.path), status: 200, layout: :layout)
      page_content = proc { renderer_for_page(file).render(view) }
      set_content_type
      body << begin
        renderer_for_layout(layout).render(view, &page_content)
      rescue Flatrack::FileNotFound
        page_content.call
      end
      [status, headers, body]
    end

    private

    def body
      @body ||= []
    end

    def headers
      @headers ||= {}
    end

    def set_content_type
      headers['Content-Type'] = FORMATS[request.format.to_sym]
    end

    def file_for(path)
      if File.directory?(File.join 'pages', path)
        File.join(path, DEFAULT_FILE)
      else
        path
      end
    end

    def renderer_for_page(file)
      Template.find :page, file
    end

    def renderer_for_layout(file)
      Template.find :layout, File.join("#{file}.#{request.format}")
    end

    def view
      @view ||= View.new(self)
    end
  end
end
