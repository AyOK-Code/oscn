module Importers
  module TulsaBlotter
    class DailyImport
      def initialize(date)
        @date = date
      end

      def perform
        save_pages
      end

      def save_pages
        pages_json.each do |page_json|
          save_page(page_json)
        end
      end

      def save_page(json)
        ::TulsaBlotter::PageHtml.create!(
          page_number: json['Page Number'],
          html: json['Bookings Html'],
          scraped_at: DateTime.now,
          inmates: json['Data'].map{ |inmate_json| upsert_inmate(inmate_json)}
        )
      end

      def upsert_inmate(json)
        #todo: add unique constraint on booking id
        inmate = ::TulsaBlotter::Inmate.upsert(:)
      end

      def pages_json
        @pages_json ||= [
          {
            'Page Number': 1,
            'Bookings Html': '<html>...</html>',
            'Data': {
              'Address': '304 N DETROID AVE Apt. F28 RR-2',
              'Booking Date': '10/6/2022',
              'Booking ID': '20221006008',
              'City/State/Zip': 'TULSA OK 74103',
              'DLM': '1191333',
              'Eyes': 'BLU',
              'First': 'SANDY',
              'Gender': 'F',
              'Hair': 'BRO',
              'Height': '5\'  03"',
              'Last': 'GRAVES',
              'Middle': 'CARTER',
              'Race': 'W',
              'Weight': '185',
              'Details Html': '<html>...</html>',
              'Arrests': [
                {
                  'Arrest Date': '10/6/2022',
                  'Arrest Time': '10:20 AM',
                  'Arrested By': 'TCSO / 4705',
                  'Booking Date': '10/6/2022',
                  'Booking Time': '11:02 AM',
                  'Release Date': '',
                  'Release Time': ''
                }
              ],
              'Offenses':
                [
                  {
                    'Bond Amt': '$250,000.00',
                    'Bond Type': 'Surety Bond',
                    'Case #': 'CF-2022-1272',
                    'Court Date': '10/22/2022',
                    'Description': 'CHILD ENDANGERMENT',
                    'Disposition': ''
                  }
                ]
            }
          }
        ]
      end
    end
  end
end
