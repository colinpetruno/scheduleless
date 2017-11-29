class PublicCompany < ApplicationRecord
  before_save :set_uuid

  update_index "company_search#public_company", :self

  def self.find_by!(hash)
    if hash[:uuid].present?
      hash[:uuid] = hash[:uuid].split("-").first
    end

    super(hash)
  end

  def as_json(_options={})
    {
      uuid: self.uuid,
      name: self.name,
      to_param: self.to_param
    }
  end

  def to_param
    "#{uuid}-harrassment-at-#{name.parameterize}"
  end

  private

  def set_uuid
    return if self.uuid.present?
    self.uuid = SecureRandom.hex(6)
  end
end
