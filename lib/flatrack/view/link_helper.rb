class Flatrack
  class View
    # View helpers to render link tags
    module LinkHelper
      include TagHelper

      # Creates an HTML link tag
      #
      # @overload link_to(href, options={})
      #   Creates an html link tag to URL, using the URL as the content
      #   of the tag.
      #
      #   @param href [String] the link
      #   @param options [Hash] html options for the tag
      #   @return [String]
      #
      # @overload link_to(content, href, options={})
      #   Creates an html link tag to URL, using the provided content as the
      #   content of the tag.
      #
      #   @param content [String] the content to be displayed for the link tag
      #   @param href [String] the link
      #   @param options [Hash] html options for the tag
      #   @return [String]
      #
      # @overload link_to(href, options={}, &block)
      #   Creates an html link tag to URL, using the provided return value of
      #   the block as the content of the tag.
      #
      #   @param href [String] the link
      #   @yield the content of the tag
      #   @return [String]
      def link_to(*args, &block)
        href, options, block = link_to_options(*args, &block)
        html_tag :a, link_to_tag_options(href, options || {}), &block
      end

      private

      def link_to_options(content_or_href = nil, href_or_options = nil,
        options = nil, &block)
        if block_given?
          [content_or_href, href_or_options, block]
        elsif href_or_options.is_a?(Hash) || href_or_options.blank?
          [content_or_href, href_or_options, proc { content_or_href }]
        else
          [href_or_options, options, proc { content_or_href }]
        end
      end

      def link_to_tag_options(link, opts = {})
        link << '?' + opts.delete(:params).to_param if opts[:params].present?
        { href: link }.merge(opts)
      end
    end
  end
end
