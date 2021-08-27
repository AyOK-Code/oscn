module Matchers
  # Splits the full name into
  class PartyNameSplitter
    attr_reader :party, :full_name, :split_name, :split_count

    def initialize(party, full_name)
      @party = party
      @full_name = full_name
      @split_name = full_name.split(/\p{Space}\p{Space}/)
      @split_count = split_name.count
    end

    def perform
      case split_count
      when 5
        update_five_name(split_name)
      when 4
        update_four_name(split_name)
      when 3
        update_three_name(split_name)
      when 2
        update_two_name(split_name)
      end
    end

    def update_five_name(split_name)
      party.update(first_name: clean_string(split_name[1]),
                   middle_name: "#{clean_string(split_name[2])} #{clean_string(split_name[3])}",
                   last_name: clean_string(split_name[0]),
                   suffix: clean_string(split_name[4]))
    end

    def update_four_name(split_name)
      party.update(first_name: clean_string(split_name[1]),
                   middle_name: clean_string(split_name[2]),
                   last_name: clean_string(split_name[0]),
                   suffix: clean_string(split_name[3]))
    end

    def update_three_name(split_name)
      party.update(first_name: clean_string(split_name[1]),
                   middle_name: clean_string(split_name[2]),
                   last_name: clean_string(split_name[0]))
    end

    def update_two_name(split_name)
      party.update(first_name: clean_string(split_name[1]),
                   last_name: clean_string(split_name[0]))
    end

    def clean_string(string)
      string.gsub(',', '').squish
    end
  end
end
