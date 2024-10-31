class LexusNexus::Crime < ApplicationRecord
  UNIQUE_BY = [:agency, :incident_number, :incident_at]
  validates :incident_number, presence: true

  def self.unique(obj_hashes)
    obj_hashes
      .group_by { |v| self::UNIQUE_BY.map { |unique_key| v[unique_key] } }
      .map{|_k,v| v[0]}
  end
end
