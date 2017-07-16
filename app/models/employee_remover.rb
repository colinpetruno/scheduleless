class EmployeeRemover
  def self.for(user)
    new(user: user)
  end

  def initialize(user:)
    @user = user
  end

  def removeable?
    user.shifts.blank?
  end

  def remove
    if removeable?
      user.update_columns(
        email: deleted_email,
        deleted_at: DateTime.now
      )
    else
      false
    end
  end

  private

  attr_reader :user

  def deleted_email
    if user.email.present?
      # ensures the email is unique in the event they sign up again
      "#{DateTime.now.to_i}-deleted-#{user.email}"
    else
      nil
    end
  end
end
