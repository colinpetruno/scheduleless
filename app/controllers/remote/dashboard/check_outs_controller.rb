module Remote
  module Dashboard
    class CheckOutsController < AuthenticatedController
      def create
        shift = current_user.shifts.find(params[:shift_id])
        check_out = CheckOut.for(shift)

        authorize check_out

        @saved = check_out.check_out
      end
    end
  end
end
