module Matchers
  # Returns possible matches for a party
  class FuzzyParty
    attr_reader :party_id, :party

    def initialize(party_id)
      @parties_hash = ::Party.pluck(:full_name, :id).to_h
      @party = ::Party.find(party_id)
    end


    def find_matching_birth
      parties = ::Party.where(birth_month: @party.birth_month, birth_year: @party.birth_year).pluck(:last_name, :first_name).map { |e| e.join(' ')  }
      fz = FuzzyMatch.new(parties)
      matches = fz.find_all("#{party.last_name} #{party.first_name}", threshold: 0.8)
      byebug
    end
  end
end
