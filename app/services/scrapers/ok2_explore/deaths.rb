module Scrapers
  module Ok2Explore
    class Deaths
      attr_reader :year

      def initialize(year)
        @year = year
      end

      def self.perform(year)
        new(year).perform
      end

      def perform
        errors = []
        (1..12).each do |month|
          ('a'..'z').to_a.each do |first_letter|
            ('a'..'z').to_a.each do |last_letter|
              DeathWorker.perform_async(year, month, first_letter, last_letter)
            end
          end
        end
      end
    end
  end
end
