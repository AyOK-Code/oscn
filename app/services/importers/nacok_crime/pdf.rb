require 'open-uri'

module Importers
  module NacokCrime
    class Pdf < ApplicationService
      attr_reader :link

      def initialize(link)
        @link = link
        super()
      end

      def perform
        parse_pages
      end

      def parse_pages
        io = URI.parse(link).open.read
        reader = PDF::Reader.new(io)
        puts reader.info
        all_pages = []
        reader.pages.each do |page|
          all_pages << page_to_dict(page)
        end
        crime_data = all_pages.flatten.compact.map do |crime|
          {
            agency: 'Oklahoma City Police Department',
            address: crime['Address'],
            incident_at: parse_datetime(crime['Date']),
            crime: crime['Offense'],
            crime_class: crime['Description'],
            incident_number: crime['Case Number']
          }
        end
        ::LexusNexus::Crime.upsert_all(
          ::LexusNexus::Crime.unique(crime_data),
          unique_by: LexusNexus::Crime::UNIQUE_BY
        )
      end

      def parse_datetime(datetime)
        DateTime.strptime(datetime, '%Y-%m-%d %H%M')
      rescue StandardError
        puts "invalid date #{datetime}"
        nil
      end

      def page_to_dict(page)
        header_index = 4

        lines = page.text.split("\n\n")
        header_row = lines[header_index]
        table_rows = lines[(header_index + 1)...]
                     .reject { |row| excluded_row?(row) }
                     .compact_blank

        return if table_rows.empty?

        cols = columns(header_row)
        page_dicts = []
        table_rows.each do |row|
          page_dicts << row_to_dict(cols, row)
        end
        page_dicts
      end

      def excluded_row?(row)
        exclude_rows_with_text = [
          'Total incidents',
          'Reporting Dates:'
        ]
        exclude_rows_with_text.any? { |text| row.include?(text) }
      end

      def columns(header_row)
        cols = {}
        # Time is not included in column names so that it will be included with Date due to parsing difficulties
        column_names = ['Address', 'Date', 'Offense', 'Description', 'Division', 'Case Number']
        column_names.each_with_index do |column, i|
          next_column = column_names[i + 1]
          cols[column] = {
            start: header_row.split(column)[0].length,
            end: next_column ? header_row.split(next_column)[0].length : header_row.length + 1
          }
        end
        cols
        # { 'Address': { start: 0, end: 28 },
        #   'Date': { start: 28, end: 39 },
        #   'Time': { start: 39, end: 49 },
        #   'Offense': { start: 49, end: 104 },
        #   'Description': { start: 104, end: 125 },
        #   'Division': { start: 125, end: 140 },
        #   'Case Number': { start: 140, end: 152 } }
      end

      def row_to_dict(cols, row)
        row_dict = {}
        cols.each do |column, indexes|
          row_dict[column] = (row[indexes[:start]...indexes[:end]]).strip
        end
        row_dict
      end
    end
  end
end
