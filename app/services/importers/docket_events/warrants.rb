module Importers
  module DocketEvents
    # Saves the warrant information to the database
    class Warrant
      attr_accessor :docket_event

      def initialize(docket_event)
        @docket_event = docket_event
        @judges = Judge.pluck(:name)
        # TODO: Refactor into matching class for judges
        matcher = FuzzyMatch.new(judges)
      end

      def perform
        # TODO: Add helpful message about the code not being for warrants
        raise StandardError if docket_event.code != 'WAI$'
        desc = warrant.description
        money = desc.scan /$?[0-9]{1,3}(?:,?[0-9]{3})*\.[0-9]{2}/
        bond = money.first
        begin
          comment = desc.split('COMMENT:')[1]
          judge_string = desc.split('JUDGE:')[1].split('-')[0]
          fz = matcher.find(judge_string, threshold: 0.8)
          if fz.nil?
            matches[:not_matched] += 1
          else
            matches[:matched] += 1
          end
        rescue
          # byebug
        end
      end
  end
end
