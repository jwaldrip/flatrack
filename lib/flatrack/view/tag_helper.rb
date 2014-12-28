class Flatrack
  class View
    # View helpers for rendering various html tags
    module TagHelper
      include CaptureHelper
      include ERB::Util

      # @private
      PRE_CONTENT_STRINGS = {
          textarea: "\n"
      }

      # @private
      BOOLEAN_ATTRIBUTES  = %w(disabled readonly multiple checked autobuffer
                              autoplay controls loop selected hidden scoped
                              async defer reversed ismap seamless muted
                              required autofocus novalidate formnovalidate open
                              pubdate itemscope allowfullscreen default inert
                              sortable truespeed typemustmatch).to_set

      # Creates an HTML tag
      #
      # @overload html_tag(name, content, options={})
      #   Creates an html tag using the provided content as the content of the
      #   tag.
      #
      #   @param name [String] the name of the tag (i.e. a, img, style)
      #   @param content [String] the content of the tag
      #   @param options [Hash] the html options for the tag
      #   @return [String]
      #
      # @overload html_tag(name, options={}, &block)
      #   Creates an html tag using the provided content as the content of the
      #   tag.
      #
      #   @param name [String] the name of the tag (i.e. a, img, style)
      #   @param options [Hash] the html options for the tag
      #   @yield the tag content
      #   @return [String]
      def html_tag(name, *args, &block)
        content, options, escape = args
        if block_given?
          check_arguments [name, *args], 1..3
          options, escape = content, options
          content = capture(&block)
        else
          check_arguments [name, *args], 2..4
        end
        escape = true if escape.nil?
        html_tag_string(name, content, options, escape)
      end

      # Returns an HTML image tag
      # @param uri [String] location of the image
      # @param options [Hash] the html options for the tag
      # @return [String]
      def image_tag(uri, options = {})
        uri = asset_path(uri) unless uri =~ %r{^(http)?(s)?:?\/\/}
        options.merge! src: uri
        html_tag(:img, nil, options)
      end

      # Returns an HTML script tag for javascript
      # @param uri [String] location of the javascript file
      # @return [String]
      def javascript_tag(uri)
        uri = asset_path(uri) + '.js' if uri.is_a? Symbol
        html_tag(:script, '', src: uri, type: 'application/javascript')
      end

      # Returns an HTML link tag for css
      # @param uri [String] location of the css file
      # @return [String]
      def stylesheet_tag(uri)
        uri = asset_path(uri) + '.css' if uri.is_a? Symbol
        html_tag(:link, nil, rel: 'stylesheet', type: 'text/css', href: uri)
      end

      private

      def check_arguments(args, number_or_range)
        range = number_or_range.is_a?(Fixnum) ? [number_or_range] : number_or_range
        unless range.include? args.size
          raise ArgumentError, "wrong number of arguments (#{args.count} for #{number_or_range.inspect})"
        end
      end

      def html_tag_string(name, content, options, escape = true)
        tag_options = tag_options(options, escape) if options
        content     = h(content) if escape && !content.nil?
        '<'.tap do |tag|
          tag << name.to_s
          tag << tag_options.to_s
          content_with_ending = content.nil? ? '/>' : ">#{content}</#{name}>"
          tag << content_with_ending
        end.html_safe
      end

      def tag_options(options = {}, escape = true)
        attrs = build_tag_options(options, escape)
        " #{attrs * ' '}" unless attrs.blank?
      end

      def build_tag_options(options = {}, escape = true)
        (options || {}).reduce([]) do |attrs, (key, value)|
          if key.to_s == 'data' && value.is_a?(Hash)
            attrs += data_tag_options(value, escape)
          elsif BOOLEAN_ATTRIBUTES.include?(key.to_s)
            attrs << boolean_tag_option(key, value)
          elsif !value.nil?
            attrs << tag_option(key, value, escape)
          end
          attrs
        end.compact.sort
      end

      def data_tag_options(hash, escape = true)
        hash.each_pair.map do |k, v|
          data_tag_option(k, v, escape)
        end
      end

      def data_tag_option(key, value, escape)
        key   = "data-#{key.to_s.dasherize}"
        value = value.to_json unless value.is_a?(String) ||
            value.is_a?(Symbol) ||
            value.is_a?(BigDecimal)
        tag_option(key, value, escape)
      end

      def boolean_tag_option(key, bool)
        %(#{key}="#{key}") if bool
      end

      def tag_option(key, value, escape)
        value = value.join(' ') if value.is_a?(Array)
        value = h(value) if escape
        %(#{key}="#{value}")
      end
    end
  end
end
