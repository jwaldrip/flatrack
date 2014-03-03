class Flatrack
  class Response
    class ViewContext
      include AssetExtensions

      def initialize(response)
        @response = response
      end

      def get_binding(&block)
        binding(&block)
      end

      def path
        @response.request.path
      end

      def params
        @response.request.params
      end

      def files
        Dir.glob(File.join 'pages', path, '*').map do |file|
          File.basename File.basename(file, '.*'), '.*'
        end - [DEFAULT_FILE]
      end

      def image_tag(uri, options = {})
        uri = File.join('/assets', uri.to_s) + '.js' if uri.is_a? Symbol
        html_tag(:img, { src: uri }.merge(options))
      end

      def javascript_tag(uri)
        uri = File.join('/assets', uri.to_s) + '.js' if uri.is_a? Symbol
        html_tag(:script, src: uri) { nil }
      end

      def stylesheet_tag(uri)
        uri = File.join('/assets', uri.to_s) + '.css' if uri.is_a? Symbol
        html_tag(:link, rel: 'stylesheet', type: 'text/css', href: uri)
      end

      def page_stylesheet_tag
        file      = @response.send(:file_for, path.to_s)
        base_path = File.join File.dirname(file), File.basename(file, '.*')
        stylesheet_tag base_path if stylesheet_exists?(base_path)
      end

      def link_to(name, link, options = {})
        if options[:params].is_a?(Hash) && options[:params].present?
          link = [link, options.delete(:params).to_param].join('?')
        end
        html_tag(:a, { href: link }.merge(options)) { name }
      end

      def html_tag(tag, options = {}, &block)
        [].tap do |lines|
          tag_options = options.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')
          lines << "<#{tag} #{tag_options}"
          if block_given?
            lines.last << '>'
            lines << yield
            lines << "</#{tag}>"
          else
            lines.last << '/>'
          end
        end.compact.join("\n")
      end

      private

      def stylesheet_exists?(name)
        Flatrack.assets[name]
      end

      def javascript_exists?(name)
        Flatrack.assets[name]
      end
    end
  end
end
