module Importers
  # Imports Issue data from parsed json
  class IssueParty
    attr_accessor :issue, :party_matcher, :logs
    attr_reader :issue_party_json

    def initialize(issue, issue_party_json, logs)
      @issue_party_json = issue_party_json
      @issue = issue
      @party_matcher = Matchers::Party.new(issue.court_case)
      @logs = logs
    end

    def self.perform(issue, issue_party_json, logs)
      new(issue, issue_party_json, logs).perform
    end

    def perform
      issue_party_json.each do |issue_party_data|
        save_issue_party(issue_party_data)
      end
    end

    def find_issue_party(issue_party_data)
      ::IssueParty.find_or_initialize_by(
        issue_id: issue.id,
        party_id: party_matcher.party_id_from_name(issue_party_data[:name])
      )
    end

    def save_issue_party(issue_party_data)
      ip = find_issue_party(issue_party_data)
      ip.assign_attributes(issue_party_attributes(issue_party_data))

      begin
        ap ip
        ip.save!
      rescue StandardError
        message = "#{issue.court_case.case_number}: Error creating issue party"
        logs.create_log('issues', message, issue_party_attributes)
      end
    end

    def issue_party_attributes(issue_party_data)
      verdict_id = find_or_create_verdict(issue_party_data[:verdict]&.downcase)

      {
        disposition_on: issue_party_data[:disposition_on],
        verdict_id: verdict_id,
        verdict_details: issue_party_data[:verdict_detail]
      }
    end

    def find_or_create_verdict(verdict)
      verdict_id = Verdict.find_by(name: verdict)&.id
      return verdict_id if verdict_id

      new_verdict = Verdict.create(name: verdict)
      new_verdict.id
    end
  end
end
