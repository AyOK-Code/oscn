module Importers
  module DocketEvents
    # Saves the docket event to the database
    class Link
      attr_accessor :docket_event
      attr_reader :link_json

      def initialize(link_json, docket_event)
        @link_json = link_json
        @docket_event = docket_event
      end

      def self.perform(link_json, docket_event)
        new(link_json, docket_event).perform
      end

      def perform
        expected_links = link_json.count
        link_json.each do |link_data|
          del = save_docket_event_link(link_data)
          next if del.nil? || del.title != 'PDF'
          save_pdf(link_data[:link], del)
        end
        links = docket_event.links.count

        return unless links != expected_links
      end

      def save_docket_event_link(link_data)
        docket_event_link = find_or_initialize_docket_event_link(link_data)

        docket_event_link.save! ? docket_event_link : nil
      end

      def save_pdf(link, docket_event_link)
        return unless ['SC', 'CJ'].include?(docket_event.court_case.case_type.abbreviation)

        ::Importers::DocketEvents::Pdf.perform(link, docket_event_link)
      end

      def find_or_initialize_docket_event_link(link_data)
        ::DocketEventLink.find_or_initialize_by(
          docket_event_id: docket_event.id,
          oscn_id: link_data[:oscn_id],
          title: link_data[:title],
          link: link_data[:link]
        )
      end
    end
  end
end
