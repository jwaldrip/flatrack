class Flatrack
  class Response
    autoload :ViewContext, 'flatrack/response/view_context'

    DEFAULT_FILE  = 'index'
    CONTENT_TYPES = {
      html: 'text/html',
      rb:   'text/html'
    }

    attr_reader :request

    def initialize(request)
      @request = request
    end

    def headers
      @headers ||= {}
    end

    def body
      @body ||= []
    end

    def render(file: file_for(request.path), status: 200, layout: :layout)
      page_content = proc { renderer_for(file).render(view_context) }
      set_content_type
      body << begin
        layout_for(layout).render(view_context, &page_content)
      rescue Flatrack::FileNotFound
        page_content.call
      end
      [status, headers, body]
    end

    def set_content_type
      headers['Content-Type'] = CONTENT_TYPES[request.format.to_sym]
    end

    private

    def file_for(path)
      if File.directory?(File.join 'pages', path)
        File.join(path, DEFAULT_FILE)
      else
        path
      end
    end

    def renderer_for(file)
      Renderer.find file
    end

    def layout_for(file)
      Renderer.find File.join("#{file}.#{request.format}")
    end

    def view_context
      @view_context ||= ViewContext.new(self)
    end
  end
end
