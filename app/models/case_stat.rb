class CaseStat < ApplicationRecord
  belongs_to :court_case

  def readonly?
    true
  end
end
