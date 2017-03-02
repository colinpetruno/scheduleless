class Registration
  include ActiveModel::Model

  attr_accessor :company_params, :user_params

  def register
    user.valid?
  end

  def company
    user.company
  end

  def user
    @_company ||= User.create(user_params)
  end

  def errors
    user.errors
  end
end
