class PreferenceFinder
  def self.for(record)
    new(record: record).locate
  end

  def initialize(record:)
    @record = record
  end

  def locate
    if record.is_a?(Company)
      record.preference
    else
    end
  end

  private

  def prioritized_preference
    if record.preference.use_company_settings?
      record.company.preference
    else
      record.preference
    end
  end

  attr_reader :record
end
