module Importers
  # Imports Count data from parsed json
  class Count
    attr_accessor :court_case, :party_matcher, :logs, :pleas, :verdicts
    attr_reader :counts_json

    def initialize(counts_json, court_case, logs)
      @counts_json = counts_json
      @court_case = court_case
      @pleas = Plea.pluck(:name, :id).to_h
      @verdicts = Verdict.pluck(:name, :id).to_h
      @party_matcher = Matchers::Party.new(court_case)
      @logs = logs
    end

    def self.perform(counts_json, court_case, logs)
      new(counts_json, court_case, logs).perform
    end

    def perform
      counts_json.each do |count_data|
        save_counts(count_data)
      end
    end

    def find_count(count_data)
      ::Count.find_or_initialize_by(
        court_case_id: court_case.id,
        party_id: party_matcher.party_id_from_name(count_data[:party_name]),
        offense_on: count_data[:offense_on],
        as_filed: count_data[:as_filed]
      )
    end

    def save_counts(count_data)
      c = find_count(count_data)

      c.assign_attributes(count_attributes(count_data))
      begin
        c.save!
      rescue StandardError
        logs.create_log('counts', "#{court_case.case_number} skipped count due to missing party.", count_data)
      end
    end

    def count_attributes(count_data)
      plea_id = find_or_create_plea(count_data[:plea]&.downcase)
      verdict_id = find_or_create_verdict(count_data[:verdict]&.downcase)
      {
        filed_statute_violation: count_data[:filed_statute_violation],
        disposition: count_data[:disposition],
        disposition_on: count_data[:disposition_on],
        disposed_statute_violation: count_data[:disposed_statute_violation],
        charge: count_data[:charge],
        plea_id: plea_id,
        verdict_id: verdict_id
      }
    end

    def find_or_create_plea(plea)
      plea_id = pleas[plea]
      return nil if plea.nil?

      return plea_id if plea_id

      new_plea = Plea.create(name: plea)
      new_plea.id
    end

    def find_or_create_verdict(verdict)
      verdict_id = verdicts[verdict]
      return verdict_id if verdict_id

      new_verdict = Verdict.create(name: verdict)
      new_verdict.id
    end
  end
end
