class Flatrack
  class View
    # View helpers for rendering various html tags
    module TagHelper
      include CaptureHelper
      include ERB::Util

      PRE_CONTENT_STRINGS = {
        textarea: "\n"
      }

      BOOLEAN_ATTRIBUTES = %w(disabled readonly multiple checked autobuffer
                              autoplay controls loop selected hidden scoped
                              async defer reversed ismap seamless muted
                              required autofocus novalidate formnovalidate open
                              pubdate itemscope allowfullscreen default inert
                              sortable truespeed typemustmatch).to_set

      def html_tag(name, content_or_options_with_block = nil, options = nil,
        escape = true, &block)
        if block_given?
          if content_or_options_with_block.is_a?(Hash)
            options = content_or_options_with_block
          end
          html_tag_string(name, capture(&block), options, escape)
        else
          html_tag_string(name, content_or_options_with_block, options, escape)
        end
      end

      def image_tag(uri, options = {})
        uri = asset_path(uri) unless uri =~ %r{^(http)?(s)?:?\/\/}
        options.merge! src: uri
        html_tag(:img, nil, options)
      end

      def javascript_tag(uri)
        uri = asset_path(uri) + '.js' if uri.is_a? Symbol
        html_tag(:script, '', src: uri, type: 'application/javascript')
      end

      def stylesheet_tag(uri)
        uri = asset_path(uri) + '.css' if uri.is_a? Symbol
        html_tag(:link, nil, rel: 'stylesheet', type: 'text/css', href: uri)
      end

      private

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
