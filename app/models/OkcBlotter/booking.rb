class OkcBlotter::Booking < ApplicationRecord
  belongs_to :pdf, class_name: 'OkcBlotter::Pdf'
  belongs_to :roster, optional: true
  has_many :offenses, class_name: 'OkcBlotter::Offense', dependent: :destroy

  def to_roster
    {
      birth_year: dob.year,
      birth_month: dob.month,
      birth_day: dob.day,
      sex: sex,
      race: race,
      street_address: nil,
      zip: zip,
      first_name: first_name,
      last_name: last_name,
      middle_name: nil
    }
  end

  def roster_snapshot_date
    pdf.date
  end
end
