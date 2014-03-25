class Flatrack
  class View
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
