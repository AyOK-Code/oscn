module Matchers
  # Returns possible matches for a party
  class FuzzyParty
    attr_reader :party_id, :party, :month, :year

    def initialize(party_id)
      @parties_hash = ::Party.pluck(:full_name, :id).to_h
      @party = ::Party.find(party_id)
      @month = @party.birth_month
      @year = @party.birth_year
    end

    # TODO: Finish fuzzy matcher
    def find_matching_birth
      parties = ::Party.where(birth_month: month, birth_year: year)
                       .pluck(:last_name, :first_name)
                       .map { |e| e.join(' ') }
      fz = FuzzyMatch.new(parties)
      fz.find_all("#{party.last_name} #{party.first_name}", threshold: 0.8)
    end
  end
end
