module InProgressShifts
  class DeleteConfirmation
    include ActiveModel::Conversion
    attr_reader :in_progress_shift

    def self.for(in_progress_shift)
      new(in_progress_shift: in_progress_shift)
    end

    def initialize(in_progress_shift:)
      @in_progress_shift = in_progress_shift
    end

    def model_name
      ActiveModel::Name.new(self.class)
    end

    def persisted?
      false
    end

    def process
      if in_progress_shift.published?
        # TODO: delete published shifts
      end

      in_progress_shift.delete
    end
  end
end
