module FlatRack
  class Response

    autoload :ViewContext, 'flatrack/response/view_context'

    DEFAULT_FILE   = 'index'
    CONTENT_TYPES = {
      html: 'text/html',
      rb:   'text/html'
    }

    attr_reader :request

    def initialize(request)
      @request = request
    end

    def render(options={})
      file, text, status, layout = options.values_at(:file, :text, :status, :layout)
      set_content_type
      status ||= 200
      if text
        render_text text, status: status
      else
        render_file file, status: status, layout: layout
      end
    end

    def headers
      @headers ||= {}
    end

    def body
      @body ||= []
    end

    def set_content_type
      headers['Content-Type'] = CONTENT_TYPES[request.format.to_sym]
    end

    private

    def render_file(file = nil, options={})
      status, layout = options.values_at(:status, :layout)
      layout ||= :layout
      file ||= file_for(request.path)
      contents = renderer_for(file).render(view_context)
      contents = layout_for(layout).render(view_context){ contents } if layout
      self.body << contents
      [status, headers, body]
    end

    def render_text(text = '', options={})
      status = options[:status]
      [status, headers, [text.to_s]]
    end

    def file_for(path)
      File.directory?(File.join 'pages', path) ? File.join(path, DEFAULT_FILE) : path
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