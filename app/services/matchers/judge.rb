module Matchers
  # Used to fuzzy match name with judges that currently exist
  class Judge
    attr_accessor :fz, :name, :judges_hash, :county_id

    # TODO: Make County dynamic
    def initialize(county_id, name)
      @judges_hash = ::Judge.pluck(:name, :id).to_h
      @name = name
      @fz = FuzzyMatch.new(::Judge.pluck(:name))
      @county_id = county_id
    end

    def judge_id
      return if name.nil?

      judge = fz.find(name, threshold: 0.8)
      judge_id = judges_hash[judge]
      if judge_id.nil?
        judge = ::Judge.create!(name:, county_id:, judge_type: 'Inactive')
        judge.id
      else
        judge_id
      end
    end
  end
end
