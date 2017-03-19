module ActionView
  module Helpers
    module UrlHelper
      def active?(path)
        current_page?(path) ? "active" : nil
      end

      def active_link_to(name = nil, options = {}, html_options = nil, &block)
        options.merge!(class: "#{options.try(:[], :class)} active") if current_page?(name)

        link_to(name, options, html_options, &block)
      end
    end
  end
end
