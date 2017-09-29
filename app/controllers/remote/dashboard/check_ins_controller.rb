module Remote
  module Dashboard
    class CheckInsController < AuthenticatedController
      def create
        shift = current_user.shifts.find(params[:shift_id])
        check_in_creator = CheckInCreator.for(shift)

        authorize check_in_creator.check_in

        @saved = check_in_creator.save
      end
    end
  end
end
