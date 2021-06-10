# Finds the correct party
class PartyMatcher
  attr_reader :court_case

  def initialize
    @court_case = court_case
  end

  def party_id_from_name(party_name)
    parties = @court_case.parties.pluck(:full_name, :id).map { |a| [a[0].squish, a[1]] }.to_h
    parties[party_name]
  end
end
