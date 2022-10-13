module Importers
  module TulsaBlotter
    class DailyImport < ApplicationService
      def perform
        save_pages
      end

      def save_pages
        page_number = 1
        incarcerated_ids = []
        while response = page_json(page_number)
          json = JSON.parse(response)
          save_page(JSON.parse(json))
          page_number += 1
          incarcerated_ids << json['Data'].map['Booking ID']
        end
        track_released(incarcerated_ids)
      end

      def track_released(incarcerated_ids)
        :TulsaBlotter::Arrest.where(release_date: nil).where.not(booking_id: incarcerated_ids).each do |arrest|
          arrest.update!(release_date: DateTime.now)
        end
      end

      def save_page(json)
        ::TulsaBlotter::PageHtml.create!(
          page_number: json['Page Number'],
          html: json['Bookings Html'],
          scraped_at: DateTime.now,
          arrests: json['Data'].map { |inmate_json| upsert_arrest(inmate_json) }
        )
      end

      def upsert_arrest(json)
        json = json.merge(json['Arrests'][0]) # merge arrest data to top leve
        arrest = ::TulsaBlotter::Arrest.find_or_initialize_by(booking_id: json['Booking ID'])
        arrest.assign_attributes(
          address: json['Address'],
          booking_id: json['Booking ID'], # '20221006008',
          zip: json['City/State/Zip'].delete('^0-9'), # 'TULSA OK 74103',
          dlm: json['DLM'], # '1191333',
          eyes: json['Eyes'], # 'BLU',
          first: json['First'], # 'SANDY',
          gender: json['Gender'], # 'F',
          hair: json['Hair'], # 'BRO',
          height: json['Height'], # '5\'  03"',
          last: json['Last'], # 'GRAVES',
          middle: json['Middle'], # 'CARTER',
          race: json['Race'], # 'W',
          weight: json['Weight'], # '185',
          arrest_details_html: ::ArrestDetailsHtml.new(html: json['Details Html'], scraped_at: Time.current), # '<html>...</html>',
          arrest_date: DateTime.parse("#{json['Arrest Date']} #{json['Arrest Time']}"), # '10/6/2022',
          arrested_by: json['Arrested By'], # 'TCSO / 4705',
          booking_date: DateTime.parse("#{json['Booking Date']} #{json['Booking Time']}"), # '10/6/2022',
          release_date: json['Release Date'] ? DateTime.parse("#{json['Release Date']} #{json['Release Time']}") : nil,
          offenses: json['Offenses'].map do |_offense|
            upsert_offenses(arrest, json)
          end
        )
      end

      def upsert_offenses(arrest, json)
        if arrest.id
          offense = ::TulsaBlotter::Offense.find_by(case_number: json['Case Number'], arrest_id: arrest.id)
          offense ||= ::TulsaBlotter::Offense.find_by(description: json['Description'], arrest_id: arrest.id)
        end
        offense ||= ::TulsaBlotter::Offense.new
        offense.assign_attributes(
          bond_amount: json['Bond Amt'], # '$250,000.00',
          bond_type: json['Bond Type'], # 'Surety Bond',
          case_number: json['Case #'], # 'CF-2022-1272',
          court_date: json['Court Date'], # '10/22/2022',
          description: json['Description'], # 'CHILD ENDANGERMENT',
          disposition: json['Disposition']
        )
      end

      def page_json(page_number)
        Lambda.new.call('TulsaJailScraper', { 'page number': page_number })
      rescue StandardError
        false
      end
    end
  end
end
