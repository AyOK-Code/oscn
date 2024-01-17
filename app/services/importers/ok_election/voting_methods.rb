module Importers
  module OkElection
    class VotingMethods
      def self.perform
        new.perform
      end

      def perform
        data.each do |vm|
          ::OkElection::VotingMethod.create!(
            code: vm[:code],
            name: vm[:name]
          )
        end
      end

      private

      def data
        [{ code: 'IP', name: 'Voted in person at polling place' },
         { code: 'AI', name: 'Voted absentee in person' },
         { code: 'AB', name: 'Absentee' },
         { code: 'PI', name: 'Physically Incapacitated' },
         { code: 'CI', name: 'Absentee - Care of Physically Incapacitated' },
         { code: 'EI', name: 'Absentee - Emergency Incapacitated' },
         { code: 'MI', name: 'Absentee - Military' },
         { code: 'OV', name: 'Absentee - Overseas' },
         { code: 'NH', name: 'Absentee - Nursing Home' }]
      end
    end
  end
end
