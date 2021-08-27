# View that gives some high level case statistics (Drop?)
class CaseStat < ApplicationRecord
  belongs_to :court_case

  def readonly?
    true
  end
end
