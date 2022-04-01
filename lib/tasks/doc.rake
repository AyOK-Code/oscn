require 'open-uri'

namespace :doc do
  desc 'Reset database and run all tasks'
  task reset: [:environment] do
    Doc::OffenseCode.delete_all
    Doc::Status.delete_all
    Doc::Sentence.delete_all
    Doc::Alias.delete_all
    Doc::Profile.delete_all

    Importers::Doc::OffenseCode.new('2022-01').perform
    Importers::Doc::Profile.new('2022-01').perform
    Importers::Doc::Sentence.new('2022-01').perform
    Importers::Doc::Alias.new('2022-01').perform
  end

  task old_receptions: [:environment] do
    Importers::Doc::OldReceptions.new.perform
  end

  task old_exits: [:environment] do
    Importers::Doc::OldExits.new.perform
  end

  task old_sentences: [:environment] do
    Importers::Doc::OldSentences.new.perform
  end

  desc 'Import profiles'
  task profiles: [:environment] do
    Importers::Doc::Profile.new('2022-01').perform
  end

  desc 'Import sentences'
  task sentences: [:environment] do
    Importers::Doc::Sentence.new('2022-01').perform
  end

  desc 'Import aliases'
  task aliases: [:environment] do
    Importers::Doc::Alias.new('2022-01').perform
  end

  desc 'Import statutes'
  task statutes: [:environment] do
    Importers::Doc::OffenseCode.new('2022-01').perform
  end

  desc 'Import statuses'
  task :statuses, [:dir] => [:environment] do |_t, args|
    dir = args.dir
    Importers::Doc::Status.new(dir).perform
  end

  desc 'Link to OSCN'
  task :link_cases, [:county] => [:environment] do |_t, args|
    county = args.county
    Importers::Doc::LinkCases.new(county).perform
  end

  desc 'Link Sentence to OffenseCode'
  task link_offense_codes: [:environment] do
    Importers::Doc::LinkOffenseCodes.new.perform
  end
end
