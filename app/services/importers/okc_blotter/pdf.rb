require 'zip'

module Importers
  module OkcBlotter
    class Pdf < ApplicationService
      def initialize(date)
        @date = date
      end

      def json
        def pdf.path
          '/path/hack.pdf' # this is a hack see https://github.com/jnunemaker/httparty/issues/675#issuecomment-590757288
        end

        @json ||= JSON.parse(HTTParty.post(
          "#{self.class.url}/parse",
          body: { pdf: pdf },
          headers: { Authorization: self.class.auth_token }
        ).body)
      end

      def pdf
        @pdf ||= Bucket.new.get_object("#{self.class.s3_path}/#{@date}.pdf").body
      end

      def save
        bookings_hash = json
        ::OkcBlotter::Pdf.create!(
          parsed_on: DateTime.now.to_date,
          date: @date,
          bookings: bookings_hash.map do |booking_hash|
            build_bookings(booking_hash)
          end
        )
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

      def perform
        save
      end

      def self.import_since_last_run
        last_run_date = ::OkcBlotter::Pdf.order(date: :desc).first.date
        (last_run_date..DateTime.now.to_date).each do |date|
          import_from_website(date)
        end
      end

      def self.import_from_website(date = nil)
        download_pdfs_from_website(date)
        begin
          perform(date)
        rescue StandardError
          puts "error processing #{date}. Data not saved" #todo: log these somewhere?
        end
      end

      # TODO: simplify this code since we're only getting one pdf (needs to be )
      def self.download_pdfs_from_website(date = nil)
        input = HTTParty.get("#{url}/pdfs?date=#{date}",
                             headers: {
                               Authorization: auth_token
                             }).body
        dates = []
        Zip::InputStream.open(StringIO.new(input)) do |io|
          while entry = io.get_next_entry
            pdf = io.read
            filename = entry.name
            Bucket.new.put_object("#{s3_path}/#{filename}", pdf)
            dates << filename.chomp!('.pdf')
          end
        end
        dates
      end

      def self.s3_path
        'okc_blotter'
      end

      def self.url
        'https://okc-blotter.herokuapp.com'
      end

      def self.auth_token
        ENV['OKC_BLOTTER_AUTH_TOKEN']
      end
    end
  end
end
