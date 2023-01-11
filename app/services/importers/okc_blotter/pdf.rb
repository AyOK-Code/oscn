require 'zip'

module Importers
  module OkcBlotter
    class Pdf < ApplicationService
      def initialize(date)
        @date = date
        super()
      end

      def perform
        download_pdf_from_website unless pdf
        save
      end

      def download_pdf_from_website
        input = HTTParty.get("#{url}/pdfs?date=#{@date}", headers: { Authorization: auth_token }).body
        Zip::InputStream.open(StringIO.new(input)) do |io|
          while (entry = io.get_next_entry) # NOTE: there is only actually one pdf here
            pdf = io.read
            filename = entry.name
            Bucket.new.put_object("#{s3_path}/#{filename}", pdf)
          end
        end
      end

      def save
        bookings_hash = json
        ::OkcBlotter::Pdf.create!(
          parsed_on: DateTime.now,
          date: @date,
          bookings: bookings_hash.map do |booking_hash|
            build_bookings(booking_hash)
          end
        )
      end

      def json
        def pdf.path
          '/path/hack.pdf' # this is a hack see https://github.com/jnunemaker/httparty/issues/675#issuecomment-590757288
        end

        return @json if @json

        response = HTTParty.post(
          "#{url}/parse",
          body: { pdf: pdf },
          headers: { Authorization: auth_token }
        )
        @json = JSON.parse(response.body)
        return @json if response.success?

        raise StandardError, "Error parsing pdf: #{@json['message']}"
      end

      def pdf
        return @pdf if @pdf

        pdf = begin
          Bucket.new.get_object("#{s3_path}/#{@date}.pdf").body
        rescue StandardError
          false
        end
        @pdf = pdf if pdf
        pdf
      end

      def build_bookings(booking_hash)
        ::OkcBlotter::Booking.new({
                                    dob: booking_hash['dob'],
                                    sex: booking_hash['sex'],
                                    last_name: booking_hash['lastName'],
                                    first_name: booking_hash['firstName'],
                                    race: booking_hash['race'],
                                    booking_number: booking_hash['bookingNumber'],
                                    booking_date: booking_hash['bookingDate'],
                                    inmate_number: booking_hash['inmateNumber'],
                                    transient: booking_hash['transient'],
                                    zip: booking_hash['zip'],
                                    booking_type: booking_hash['bookingType'],
                                    offenses: booking_hash['offenses'].map do |offense_hash|
                                      build_offense(offense_hash)
                                    end
                                  })
      end

      def build_offense(offense_hash)
        ::OkcBlotter::Offense.new({
                                    type: offense_hash['type'],
                                    bond: offense_hash['bond'],
                                    code: offense_hash['code'],
                                    dispo: offense_hash['dispo'],
                                    charge: offense_hash['charge'],
                                    warrant_number: offense_hash['warrantNumber'],
                                    citation_number: offense_hash['citationNumber']
                                  })
      end

      def s3_path
        'okc_blotter'
      end

      def url
        'https://okc-blotter.herokuapp.com'
      end

      def auth_token
        ENV.fetch('OKC_BLOTTER_AUTH_TOKEN', nil)
      end

      def self.import_since_last_run
        last_run_date = ::OkcBlotter::Pdf.order(date: :desc).first.date
        (last_run_date + 1.day..DateTime.now.to_date).each do |date|
          perform(date)
        rescue StandardError => e
          error = StandardError.new("Error processing #{date}. Data not saved. Message was: #{e}")
          puts error
          Raygun.track_exception(error)
        end
      end

      # NOTE: PDFs only are on the website for 30 days but if pdfs are saved to s3 you may be able to parse longer
      def self.import_missing_dates(since_date = (DateTime.now - 1.month).to_date)
        query = <<-SQL
          SELECT * FROM generate_series('#{since_date}', '#{DateTime.now.to_date}', interval '1 day') AS dates
          WHERE dates NOT IN (SELECT date FROM okc_blotter_pdfs);
        SQL
        missing_dates = ActiveRecord::Base.connection.execute(query).to_a.map { |row| row['dates'].to_datetime.to_date }
        missing_dates.each do |date|
          perform(date)
        rescue StandardError => e
          error = StandardError.new("Error processing #{date}. Data not saved. Error was: #{e}")
          puts error
          Raygun.track_exception(error)
        end
      end
    end
  end
end
