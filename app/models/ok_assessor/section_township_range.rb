class OkAssessor::SectionTownshipRange < ApplicationRecord
  belongs_to :account, class_name: 'OkAssessor::Account'
end
