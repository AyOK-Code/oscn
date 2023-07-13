module Importers
  # Imports Issue data from parsed json
  class IssueParty
    attr_accessor :court_case, :party_matcher, :logs, :verdicts
    attr_reader :issues_json

    def initialize(issues_json, court_case, logs)
      @issues_json = issues_json
      @court_case = court_case
      @verdicts = Verdict.pluck(:name, :id).to_h
      @party_matcher = Matchers::Party.new(court_case)
      @logs = logs
    end

    def self.perform(issues_json, court_case, logs)
      new(issues_json, court_case, logs).perform
    end

    def perform
      issues_json.each do |issue_data|
        save_issue(issue_data)
      end
    end

    def find_issue_party(issue_data)
      ::IssueParty.find_or_initialize_by(
        court_case_id: court_case.id,
        number: issue_data[:number]
      )
    end

    def save_issue(issue_party_data)
      ip = find_issue_party(issue_party_data)
      ip.assign_attributes(issue_party_attributes(issue_party_data))

      begin
        ip.save!
        # TODO: Send data to IssueParty Importer
      rescue StandardError
        message = "#{court_case.case_number} skipped issue due to missing information."
        logs.create_log('issues', message, issue_party_attributes)
      end
    end

    def issue_party_attributes(issue_party_attributes)
      code_id = find_or_create_count_code(issue_party_attributes[:issue_code]&.squish)

      {
        name: issue_party_attributes[:issue_name],
        filed_by: party_matcher.party_id_from_name(issue_party_attributes[:filed_by]),
        filed_on: issue_party_attributes[:filed_on],
        count_code_id: code_id
      }
    end

    def issue_attributes(issue_party)
      verdict_id = find_or_create_verdict(issue_party[:verdict]&.downcase)

      {
        party_id: party_matcher.party_id_from_name(issue_party[:name]),
        disposition_on: issue_party[:disposition_on],
        verdict: verdict_id,
        verdict_detail: issue_party[:verdict_detail]
      }
    end

    def find_or_create_verdict(verdict)
      verdict_id = verdicts[verdict]
      return verdict_id if verdict_id

      new_verdict = Verdict.create(name: verdict)
      new_verdict.id
    end
  end
end
