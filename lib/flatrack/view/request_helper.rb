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
    end
  end
end
