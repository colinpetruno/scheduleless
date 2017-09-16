module Remote
  module Calendar
    class ShiftDetailsController < AuthenticatedController
      def show
        authorize Shift, :show?
      end
    end
  end
end
