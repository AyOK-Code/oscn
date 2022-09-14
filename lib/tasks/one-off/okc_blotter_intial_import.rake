namespace :import do
  desc 'Import cases from old oklahoma city blotter sql database'
  task okc_blotter_initial: [:environment] do
    pdf_csv = CSV.parse(
      File.read('lib/data/justice_data_dbo_pdfs.csv'),
      headers: true
    )
    pdf_csv.each do |row|
      OkcBlotter::Pdf.create!(
        id: row['id'],
        parsed_on: DateTime.parse(row['parsed_on']).to_date,
        date: row['date']
      )
    end
    people_csv = CSV.parse(
      File.read('lib/data/justice_data_dbo_people.csv'),
      headers: true
    )
    people_by_id = people_csv.to_h { |v| [v['id'], v] }
    bookings_csv = CSV.parse(
      File.read('lib/data/justice_data_dbo_bookings.csv'),
      headers: true
    )
    bookings_csv.each do |row|
      OkcBlotter::Booking.create!(
        id: row['id'],
        pdf_id: row['pdf_id'],
        first_name: people_by_id[row['person_id']]['first_name'],
        last_name: people_by_id[row['person_id']]['first_name'],
        dob: people_by_id[row['person_id']]['dob'],
        sex: row['sex'],
        race: row['race'],
        zip: row['zip'],
        transient: row['transient'] = 'true' ? true : false,
        inmate_number: row['inmate_number'],
        booking_number: row['booking_number'],
        booking_type: row['booking_type'],
        booking_date: row['booking_date'],
        release_date: row['release_date']
      )
    end

    offenses_csv = CSV.parse(
      File.read('lib/data/justice_data_dbo_offenses.csv'),
      headers: true
    )
    offenses_csv.each do |row|
      OkcBlotter::Offense.create!(
        id: row['id'],
        booking_id: row['booking_id'],
        type: row['type'],
        bond: row['bond'],
        code: row['code'],
        dispo: row['dispo'],
        charge: row['charge'],
        warrant_number: row['warrant_number'],
        citation_number: row['citation_number']
      )
    end
  end
end
