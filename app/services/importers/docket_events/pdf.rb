module Importers
  module DocketEvents
    # Saves the docket event to the database
    class Pdf
      attr_accessor :docket_event_link
      attr_reader :link

      def initialize(link, docket_event_link)
        @link = link
        @docket_event_link = docket_event_link
      end

      def self.perform(link, docket_event_link)
        new(link, docket_event_link).perform
      end

      def perform
        response = OscnRequestor.perform(link)
        docket_event_link.document.attach(io: StringIO.new(response.body), filename: docket_event_link.docket_event_id,
                                          content_type: 'application/pdf')
      end
    end
  end
end
