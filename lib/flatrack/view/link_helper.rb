class Flatrack
  class View
    module LinkHelper
      include TagHelper

      def link_to(name = nil, options = nil, html_options = nil, &block)
        if block_given?
          href, options, block = name, options, block
        elsif options.is_a?(Hash) || options.blank?
          name, href, options, block = name, name, options, block
        else
          name, href, options, block = name, options, html_options, block
        end

        block ||= proc { name }

        html_tag :a, link_to_options(href, options || {}), &block
      end

      private

      def link_to_options(link, opts = {})
        link << '?' + opts.delete(:params).to_param if opts[:params].present?
        { href: link }.merge(opts)
      end
    end
  end
end
