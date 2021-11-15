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
                                         payment: calculate_payment(data),
                                         is_otc_payment: otc?(data)
                                       })
        docket_event.save
      end

      def otc?(docket_event_data)
        docket_event_data[:description].include?('OTC')
      end

      def calculate_payment(docket_event_data)
        regex = /PAID:\s*?\$\s*?((\d|,)+\.\d+)/
        payment = regex.match(docket_event_data[:description])
        return 0 if payment.nil?

        amount = payment[1].to_f

        if amount.zero?
          intercept_regex = /#{case_number}:\s*?\$-*?(\d|,)+\.\d{2}/
          matches = docket_event_data[:description].to_enum(:scan, intercept_regex).map { Regexp.last_match }

          matches.each do |tax_intercept|
            amount += tax_intercept[0].match(/(-|\$)?(\d|,)+\.\d{2}/)[0].gsub(',', '').gsub('$', '').to_f
          end
        end

        amount.round(2)
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
