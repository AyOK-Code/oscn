class Roster < ApplicationRecord
  has_many :bookings, class_name: 'OkcBlotter::Booking', foreign_key: 'roster_id'
  has_many :inmates, class_name: 'TulsaBlotter::Inmate', foreign_key: 'roster_id'

  has_many :case_parties, foreign_key: 'roster_id'
  has_many :doc_profiles, class_name: 'Doc::Profile', foreign_key: 'roster_id'

  def sources
    bookings + case_parties + doc_profiles
  end

  def remerge
    assign_attributes(
      sources
        .sort_by(&:roster_snapshot_date)
        .inject { |obj, n| obj.merge(n) }
    )
    save!
  end

  def self.process_from_record(record)
    roster_from_record = record.to_roster
    matching_roster = find_matches(roster_from_record)
    if matching_roster
      record.update!(roster: matching_roster)
      matching_roster.remerge
    else
      new_roster = Roster.create(:roster)
      record.update!(roster: new_roster)
    end
  end

  def self.find_matches(roster)
    Roster.first(
      first_name: roster.first_name,
      last_name: roster.last_name,
      birth_year: roster.birth_year,
      birth_month: roster.birth_month,
      birth_day: roster.birth_day
    )
  end
end
