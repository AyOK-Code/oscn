module Matchers
  # Finds the correct party
  class Party
    attr_reader :court_case

    def initialize(court_case)
      @court_case = court_case
    end

    def party_id_from_name(party_name)
      parties = court_case.parties.pluck(:full_name, :id).to_h { |a| [a[0].squish, a[1]] }
      parties[party_name]
    end
  end
end
