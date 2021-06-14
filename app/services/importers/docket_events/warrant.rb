module Importers
  module DocketEvents
    # Saves the warrant information to the database
    class Warrant
      attr_accessor :docket_event, :matcher, :judges_hash, :logs

      def initialize(docket_event)
        # TODO: Refactor into matching class for judges
        @docket_event = docket_event
        @judges = ::Judge.pluck(:name)
        @judges_hash = ::Judge.pluck(:name, :id).to_h
        @matcher = FuzzyMatch.new(@judges)
        @logs = Importers::Logger.new(docket_event.court_case)
      end

      def self.perform(docket_event)
        self.new(docket_event).perform
      end

      def perform
        raise StandardError if docket_event.docket_event_type.code != 'WAI$'

        w = ::Warrant.find_or_initialize_by(docket_event_id: docket_event.id)
        w.judge_id = get_judge_id
        w.bond = get_bond
        w.comment = get_comment
        begin
          w.save!
        rescue
          create_log('warrants', 'Error saving the warrant', desc)
        end

        logs.update_logs
      end

      def desc
        docket_event.description
      end

      def get_comment
        desc&.split('COMMENT:')[1]
      end

      def get_bond
        desc = docket_event.description
        money = desc.scan /$?[0-9]{1,3}(?:,?[0-9]{3})*\.[0-9]{2}/
        m = Monetize.parse(money.first)
        m.dollars&.to_i
      end

      def get_judge_id
        begin
          judge_string = desc&.split('JUDGE:')[1]&.split('-')[0]
          judge = matcher.find(judge_string, threshold: 0.8)
          judge_id = judges_hash[judge]
        rescue NoMethodError
          logs.create_log('warrants', '"Judge:" string not found', desc)
        end
      end
    end
  end
end
