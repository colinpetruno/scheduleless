class ConfirmDelete
  include ActiveModel::Model

  attr_accessor :delete_positions, :delete_rules, :new_position_id,
    :new_rule_id, :position

  def deletable?
    position.users.blank? && position.schedule_rules.blank?
  end

  def delete
    position.update(deleted_at: DateTime.now)
  end

  def delete_with_associations
    ActiveRecord::Base.transaction do
      if delete_positions.to_i == 1 && users_present?
        delete_employee_positions
      elsif new_position_id.present? && users_present?
        remap_employee_positions
      end

      if delete_rules.to_i == 1 && schedule_rules_present?
        delete_schedule_rules
      elsif new_rule_id.present?
        remap_schedule_rules && schedule_rules_present?
      end
    end

    position.update(deleted_at: DateTime.now)

    true
  rescue StandardError => error
    false
  end

  def position_options
    position.company.positions - [position]
  end

  def schedule_rules_present?
    position.schedule_rules.present?
  end

  def users_present?
    position.users.present?
  end

  private

  def company
    position.company
  end

  def delete_employee_positions
    EmployeePosition.
      where(position_id: position.id).
      delete_all
  end

  def delete_schedule_rules
    ScheduleRule.
      where(company_id: company.id, position_id: position.id).
      delete_all
  end

  def remap_employee_positions
    EmployeePosition.
      where(position_id: position.id).
      update(position_id: new_position_id)
  end

  def remap_schedule_rules
    ScheduleRule.
      where(position_id: position.id).
      update(position_id: new_rule_id)
  end
end
