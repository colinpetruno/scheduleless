module Remote
  module NewCalendar
    class ShiftDetailsController < AuthenticatedController
      def show
        authorize Shift, :show?
      end
    end
  end
end
