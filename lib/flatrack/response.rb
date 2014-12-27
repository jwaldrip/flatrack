class Flatrack
  # Handles flatrack responses
  class Response
    # @private
    DEFAULT_FILE = 'index'

    attr_accessor :layout
    attr_reader :request
    delegate :config, :format, to: :request

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
      @file, @status, @layout = file, status, layout
      page_content            = pre_render_page
      body << begin
        renderer_for_layout(@layout).render view, &proc { page_content }
      rescue Flatrack::FileNotFound
        page_content
      end
      [status, headers, body]
    end

    # Set the layout
    # @param layout [String]
    # @return [String]
    def use_layout(layout)
      @layout = layout.to_s
    end

    private

    def pre_render_page
      renderer                = renderer_for_page(@file)
      content                 = renderer.render(view)
      @view                   = nil
      headers['Content-Type'] = FORMATS[renderer.format.to_s]
      content
    end

    def body
      @body ||= []
    end

    def headers
      @headers ||= {}
    end

    def file_for(path)
      if File.directory?(File.join 'pages', path)
        path = File.join(path, DEFAULT_FILE)
      end
      path
    end

    def renderer_for_page(file)
      Template.find config.site_root, :page, format, file
    end

    def renderer_for_layout(file)
      Template.find config.site_root, :layout, format, file
    end

    def view
      @view ||= View.new(self)
    end
  end
end
