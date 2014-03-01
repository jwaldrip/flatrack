module Flatrack
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

    def render(options = {})
      type   = [:file, :text].find { |t| options[t] } || :file
      status = options[:status]
      layout = options[:layout] unless type == :text

      set_content_type
      status ||= 200

      send("render_#{type}", options[type], status: status, layout: layout)
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

    def render_file(file = nil, options = {})
      status, layout = options.values_at(:status, :layout)
      layout         ||= :layout
      file           ||= file_for(request.path)
      page_content   = proc { renderer_for(file).render(view_context) }
      body << if layout
                layout_for(layout).render(view_context, &page_content)
              else
                page_content.call
              end
      [status, headers, body]
    end

    def render_text(text = '', options = {})
      status = options[:status]
      [status, headers, [text.to_s]]
    end

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
