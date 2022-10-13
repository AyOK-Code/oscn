module Importers
  module TulsaBlotter
    class DailyImport < ApplicationService
      def perform
        save_pages
      end

      def save_pages
        page_number = 1
        while page_json(page_number) do
          save_page(page_json)
          page_number += 1
        end
      end

      def save_page(json)
        ::TulsaBlotter::PageHtml.create!(
          page_number: json['Page Number'],
          html: json['Bookings Html'],
          scraped_at: DateTime.now,
          inmates: json['Data'].map { |inmate_json| upsert_inmate(inmate_json) }
        )
      end

      def upsert_inmate(json)
        arrest = ::TulsaBlotter::Arrest.find_or_initialize_by(booking_id: json['Booking ID'])
        arrest.assign_attributes(
          address: json['Address'], #'304 N DETROID AVE Apt. F28 RR-2',
          booking_date: json['Booking Date'], #'10/6/2022',
          booking_id: json['Booking ID'], #'20221006008',
          zip: json['City/State/Zip'].delete("^0-9"), #'TULSA OK 74103',
          dlm: json['DLM'], #'1191333',
          eyes: json['Eyes'], #'BLU',
          first: json['First'], #'SANDY',
          gender: json['Gender'], #'F',
          hair: json['Hair'], #'BRO',
          height: json['Height'], #'5\'  03"',
          last: json['Last'], #'GRAVES',
          middle: json['Middle'], #'CARTER',
          race: json['Race'], #'W',
          weight: json['Weight'], #'185',
          arrest_details_html: ArrestDetailsHtml.new(html: json['Details Html'], scraped_at: Time.current), #'<html>...</html>',
          arrest_date: DateTime.parse("#{json['Arrest Date']} #{json['Arrest Time']}"), #'10/6/2022',
          arrested_by: json['Arrested By'], #'TCSO / 4705',
          booking_date: DateTime.parse("#{json['Booking Date']} #{json['Booking Time']}"), # '10/6/2022',
          release_date: DateTime.parse("#{json['Release Date']} #{json['Release Time']}"),
          offenses: json['Offenses'].map do |offense|
            Offense.new(
              bond_amount: json['Bond Amt'], #'$250,000.00',
              bond_type: json['Bond Type'], #'Surety Bond',
              case_number: json['Case #'], #'CF-2022-1272',
              court_date: json['Court Date'], #'10/22/2022',
              description: json['Description'], #'CHILD ENDANGERMENT',
              disposition: json['Disposition']
            )
          end
        )
      end

      def page_json(page_number)
          Lambda.new.call('TulsaJailScraper', { 'page number': page_number })
        rescue
          false
        #   @pages_json ||= [
        #     {
        #       'Page Number': 1,
        #       'Bookings Html': '<html>...</html>',
        #       'Data': {
        #         'Address': '304 N DETROID AVE Apt. F28 RR-2',
        #         'Booking Date': '10/6/2022',
        #         'Booking ID': '20221006008',
        #         'City/State/Zip': 'TULSA OK 74103',
        #         'DLM': '1191333',
        #         'Eyes': 'BLU',
        #         'First': 'SANDY',
        #         'Gender': 'F',
        #         'Hair': 'BRO',
        #         'Height': '5\'  03"',
        #         'Last': 'GRAVES',
        #         'Middle': 'CARTER',
        #         'Race': 'W',
        #         'Weight': '185',
        #         'Details Html': '<html>...</html>',
        #         'Arrests': [
        #           {
        #             'Arrest Date': '10/6/2022',
        #             'Arrest Time': '10:20 AM',
        #             'Arrested By': 'TCSO / 4705',
        #             'Booking Date': '10/6/2022',
        #             'Booking Time': '11:02 AM',
        #             'Release Date': '',
        #             'Release Time': ''
        #           }
        #         ],
        #         'Offenses':
        #           [
        #             {
        #               'Bond Amt': '$250,000.00',
        #               'Bond Type': 'Surety Bond',
        #               'Case #': 'CF-2022-1272',
        #               'Court Date': '10/22/2022',
        #               'Description': 'CHILD ENDANGERMENT',
        #               'Disposition': ''
        #             }
        #           ]
        #       }
        #     }
        #   ]
      end
    end
  end
end
