class Features
  def self.for(company)
    new(company: company)
  end

  def initialize(company:)
    @company = company
  end

  def as_json(_options={})
    all_features.inject({}) do |hash, feature|
      hash[feature.key] = enabled?(feature.key)
      hash
    end
  end

  def enabled?(feature_key)
    trial? || plan_features.any? { |f| f.key == feature_key }
  end

  def time_clock?
    trial? || plan_features.any? { |f| f.key == "time_clock" }
  end

  def trading?
    trial? || plan_features.any? { |f| f.key == "trading" }
  end

  def wages?
    trial? || plan_features.any? { |f| f.key == "wages" }
  end

  private

  attr_reader :company

  def all_features
    @_features ||= Feature.all
  end

  def plan_features
    @_plan_features ||= Feature.joins(:plans).where(plans: { id: plan_id })
  end

  def plan_id
    subscription.plan_id
  end

  def trial?
    company.created_at > (Date.today - 32.days)
  end

  def subscription
    company.subscription
  end
end
