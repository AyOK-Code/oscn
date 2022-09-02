require 'zip'

module Importers
  module OkcBlotter
    class Pdf < ApplicationService
      def initialize(date)
        @date = date
      end

      def json
        # see https://github.com/jnunemaker/httparty/issues/675#issuecomment-590757288
        def pdf.path
          '/path/hack.pdf'
        end
        @json ||= JSON.parse(HTTParty.post(
          "#{self.class.url}/parse",
          body: { pdf: pdf },
          headers: { 'Authorization': self.class.auth_token }
        ).body)
      end

      def pdf
        @pdf ||= Bucket.new.get_object("#{self.class.s3_path}/#{@date}.pdf").body
      end

      def save
        test = json
        puts 'yolo'
      end

      def perform
        save
      end

      def self.import_from_website(from_date = nil)
        dates = download_from_website(from_date)
        dates.each do |date|
          self.perform(date)
        end
      end

      def self.download_from_website(from_date = nil)
        input = HTTParty.get("#{url}/pdfs?after=#{from_date}",
                             headers: {
                               'Authorization': auth_token,
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
