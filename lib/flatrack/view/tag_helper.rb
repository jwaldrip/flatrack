class Flatrack
  class View
    module TagHelper
      include CaptureHelper

      PRE_CONTENT_STRINGS = {
        :textarea => "\n"
      }

      BOOLEAN_ATTRIBUTES = %w(disabled readonly multiple checked autobuffer
                           autoplay controls loop selected hidden scoped async
                           defer reversed ismap seamless muted required
                           autofocus novalidate formnovalidate open pubdate
                           itemscope allowfullscreen default inert sortable
                           truespeed typemustmatch).to_set

      def html_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
        if block_given?
          options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
          html_tag_string(name, capture(&block), options, escape)
        else
          html_tag_string(name, content_or_options_with_block, options, escape)
        end
      end

      def image_tag(uri, options = {})
        uri = asset_path(uri) unless uri =~ /^(http)?(s)?:?\/\//
        options.merge! src: uri
        html_tag(:img, nil, options)
      end

      def javascript_tag(uri)
        uri = asset_path(uri) + '.js' if uri.is_a? Symbol
        html_tag(:script, '', src: uri)
      end

      def stylesheet_tag(uri)
        uri = asset_path(uri) + '.css' if uri.is_a? Symbol
        html_tag(:link, nil, rel: 'stylesheet', type: 'text/css', href: uri)
      end

      private

      def html_tag_string(name, content, options, escape = true)
        tag_options = tag_options(options, escape) if options
        content     = ERB::Util.h(content) if escape && !content.nil?
        '<'.tap do |tag|
          tag << name.to_s
          tag << tag_options.to_s
          content_with_ending = content.nil? ? '/>' : ">#{content}</#{name}>"
          tag << content_with_ending
        end.html_safe
      end

      def tag_options(options, escape = true)
        return if options.blank?
        attrs = options.reduce([]) do |attrs, (key, value)|
          if key.to_s == 'data' && value.is_a?(Hash)
            value.each_pair do |k, v|
              attrs << data_tag_option(k, v, escape)
            end
          elsif BOOLEAN_ATTRIBUTES.include?(key)
            attrs << boolean_tag_option(key) if value
          elsif !value.nil?
            attrs << tag_option(key, value, escape)
          end
        end
        " #{attrs.sort! * ' '}" unless attrs.blank?
      end

      def data_tag_option(key, value, escape)
        key = "data-#{key.to_s.dasherize}"
        unless value.is_a?(String) || value.is_a?(Symbol) || value.is_a?(BigDecimal)
          value = value.to_json
        end
        tag_option(key, value, escape)
      end

      def boolean_tag_option(key)
        %(#{key}="#{key}")
      end

      def tag_option(key, value, escape)
        value = value.join(" ") if value.is_a?(Array)
        value = ERB::Util.h(value) if escape
        %(#{key}="#{value}")
      end

    end
  end
end
