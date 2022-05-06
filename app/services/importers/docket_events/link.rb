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
          save_docket_event_link(link_data)
        end
        links = docket_event.links.count

        return unless links != expected_links
      end

      def save_docket_event_link(link_data)
        docket_event_link = find_or_initialize_docket_event_link(link_data)

        docket_event_link.save!
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
