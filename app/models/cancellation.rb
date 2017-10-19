class Cancellation
  attr_reader :note, :shift

  def initialize(note: nil, shift:)
    @note = note
    @shift = shift
  end

  def cancel
    shift.update(note: note, state: :cancelled)

    shift.in_progress_shift.update(edited: true, user_id: nil)

    CancelShiftNotificationJob.perform_later shift.id

    true
  rescue StandardError => error
    Bugsnag.notify(error)
    false
  end
end
