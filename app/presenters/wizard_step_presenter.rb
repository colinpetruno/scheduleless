class WizardStepPresenter
  def self.class_for(current_step, step_index)
    case
    when current_step > step_index
      "oi oi-circle-check"
    when current_step == step_index
      "oi oi-media-record current"
    else
      "oi oi-media-record"
    end
  end

  def self.list_class(current_step, step_index)
    case
    when current_step > step_index
      "completed"
    when current_step == step_index
      "current"
    else
      ""
    end
  end
end
