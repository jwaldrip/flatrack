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

      def html_tag(tag, options = {}, &block)
        meta   = options.map { |k, v| "#{k}=\"#{v}\"" }
        prefix = [tag, *meta].join(' ')
        "<#{prefix}" + (block_given? ? ">#{yield}</#{tag}>" : '/>')
      end

      def image_tag(uri, options = {})
        uri = asset_path(uri)
        html_tag(:img, { src: uri }.merge(options))
      end

      def javascript_tag(uri)
        uri = asset_path(uri) + '.js' if uri.is_a? Symbol
        html_tag(:script, src: uri) { nil }
      end

      def link_to(link_or_name, link_or_options=nil, options={})
        name = link_or_name
        link, options = if link_or_options.is_a?(Hash)
                          [name, link_or_options]
                        else
                          [link_or_options, options]
                        end

        html_tag(:a, link_to_options(link, options)) { name }
      end

      def params
        @response.request.params
      end

      def path
        @response.request.path
      end

      def stylesheet_tag(uri)
        uri = asset_path(uri) + '.css' if uri.is_a? Symbol
        html_tag(:link, rel: 'stylesheet', type: 'text/css', href: uri)
      end

      private

      def link_to_options(link, opts={})
        link << '?' + opts.delete(:params).to_param if opts[:params].present?
        { href: link }.merge(opts)
      end

    end
  end
end
