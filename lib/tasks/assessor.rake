require 'uri'

namespace :assessor do
  desc 'Import assessor data from s3 folder'
  task :import, [:folder] => [:environment] do |_t, args|
    raise StandardError, 'Missing required param: folder' if args[:folder].nil?

    folder = args[:folder]

    puts "Running Account Import"
    Importers::OkAssessor::Accounts.perform(folder)
    puts "Running Improvements Import"
    Importers::OkAssessor::Improvements.perform(folder)
    puts "Running ImprovementDetails Import"
    Importers::OkAssessor::ImprovementDetails.perform(folder)
    puts "Running LandAttributes Import"
    Importers::OkAssessor::LandAttributes.perform(folder)
    puts "Running Owners Import"
    Importers::OkAssessor::Owners.perform(folder)
    puts "Running Sales Import"
    Importers::OkAssessor::Sales.perform(folder)
    puts "Running SectionTownshipRanges Import"
    Importers::OkAssessor::SectionTownshipRanges.perform(folder)
    puts "Running ValueDetails Import"
    Importers::OkAssessor::ValueDetails.perform(folder)
  end
end
