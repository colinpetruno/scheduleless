class ApplicationPolicy
  attr_reader :current_location, :user, :record

  def initialize(context, record)
    @current_location = context.location
    @record = record
    @user = context.user
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :location, :user, :scope

    def initialize(context, scope)
      @user = context.user
      @location = context.location
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private

  def admin_for?(user)
    if user.location_admin?
      # check to ensure their locations overlap
      user.locations.where(id: record.locations.pluck(:id)).present?
    else
      # check if user is location admin anywhere
      record.
        locations.
        where(id: UserLocation.
          where(user_id: user.id, admin: true).
          pluck(:location_id)
        ).
        present?
    end
  end

  def location_admin_for?(location)
    if location.present?
      user.manage?(location) || has_overrided_location?
    else
      false
    end
  end

  def has_overrided_location?
    EmployeeLocation.
      where(user_id: user.id, location_id: current_location.id, admin: true).
      present?
  end

  def same_company?
    user.company_id == record.company_id
  end
end
