module Remote
  module InProgressShifts
    class DeleteConfirmationsController < AuthenticatedController
      def create
        shift = InProgressShift.find_by!(id: params[:in_progress_shift_id],
                                          company_id: current_company.id)
        authorize shift

        @confirmation = ::InProgressShifts::DeleteConfirmation.for(shift)

        @confirmation.process
      end

      def new
        shift = InProgressShift.find_by!(id: params[:in_progress_shift_id],
                                          company_id: current_company.id)

        authorize shift

        @confirmation = ::InProgressShifts::DeleteConfirmation.for(shift)
      end
    end
  end
end
