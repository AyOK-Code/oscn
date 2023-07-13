require 'json'
module Scrapers
  module TulsaCity
    class TulsaInmates
      attr_reader :inmates_json

      def initialize
        @inmates = []

        @inmates_json = []
      end

      def self.perform
        new.perform
      end

      def self.perform_inmates
        new.perform_inmates
      end

      def perform
        inmate_json = perform_inmates
        bar = ProgressBar.new(inmate_json.count)
        inmate_json.each do |inmate|
          TulsaCityWorker
            .set(queue: :high)
            .perform_async(inmate['IncidentRecordID'], inmate['active'])
          bar.increment!
        end
      end

      def perform_inmates
        headers = { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'Accept' => '*/*' }
        inmates_url = 'https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/CompleteInmates.aspx/ServiceReference'

        inmates = HTTParty.post(inmates_url, headers: headers)

        JSON.parse(inmates['d']['ReturnCode'])
      end
    end
  end
end
