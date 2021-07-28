module Importers
  module DocketEvents
    # Saves the docket event to the database
    class Fee
      attr_accessor :docket_event, :data, :case_number

      def initialize(docket_event, data, case_number)
        @docket_event = docket_event
        @data = data
        @case_number = case_number
      end

      def self.perform(docket_event, data, case_number)
        new(docket_event, data, case_number).perform
      end

      def perform
        docket_event.assign_attributes({
                                         adjustment: calculate_adjustment(data),
                                         payment: calculate_payment(data)
                                       })
        docket_event.save
      end

      def calculate_payment(docket_event_data)
        regex = /PAID:\s*?\$\s*?((\d|,)+\.\d+)/
        payment = regex.match(docket_event_data[:description])
        return 0 if payment.nil?

        payment[1]&.to_f
      end

      def calculate_adjustment(docket_event_data)
        return 0 if docket_event_data[:description].exclude?('ADJUSTING ENTRY')

        data = docket_event_data[:description].split(case_number)
        adjustment = 0.to_f
        money_regex = /(-|\$)?(\d|,)+\.\d{2}/

        data.each do |string|
          money = money_regex.match(string)
          next if money.nil?

          m = Monetize.parse(money[0])
          adjustment += m.dollars&.to_f
        end
        adjustment
      end
    end
  end
end
