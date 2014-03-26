class Flatrack
  class View
    # View helpers to access the params and path
    module RequestHelper
      def params
        @response.request.params
      end

      def path
        @response.request.path
      end
    end
  end
end
