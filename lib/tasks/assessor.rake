require 'uri'

namespace :assessor do
  desc 'Import assessor data from s3 folder'
  task :import, [:folder] => [:environment] do |_t, args|
    raise StandardError, 'Missing required param: folder' if args[:folder].nil?

    folder = args[:folder]

    Importers::OkAssessor::Accounts.perform(folder)
    Importers::OkAssessor::Improvements.perform(folder)
    Importers::OkAssessor::ImprovementDetails.perform(folder)
    Importers::OkAssessor::LandAttributes.perform(folder)
    Importers::OkAssessor::Owners.perform(folder)
    Importers::OkAssessor::Sales.perform(folder)
    Importers::OkAssessor::SectionTownshipRanges.perform(folder)
    Importers::OkAssessor::ValueDetails.perform(folder)
  end
end
