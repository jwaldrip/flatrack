class Flatrack
  class View
    # View helpers to access the params and path
    module RequestHelper
      # Returns the query parameters
      # @return [Hash]
      def params
        @response.request.params
      end

      # Returns the path
      # @return [String]
      def path
        @response.request.path
      end
      # Returns the cookies
      # @return [Hash]
      def cookies
        @response.request.env['rack.cookies']
      end

    end
  end
end
