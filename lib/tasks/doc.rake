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

  desc 'Import all'
  task :all, [:dir] => [:environment] do |_t, args|
    dir = args.dir
    Importers::Doc::OffenseCode.new(dir).perform
    Importers::Doc::Profile.new(dir).perform
    Importers::Doc::Sentence.new(dir).perform
    Importers::Doc::Alias.new(dir).perform
    Importers::Doc::Status.new(dir).perform
  end

  desc 'Import profiles'
  task :profiles, [:dir] => [:environment] do |_t, args|
    dir = args.dir
    Importers::Doc::Profile.new(dir).perform
  end

  desc 'Import sentences'
  task :sentences, [:dir] => [:environment] do |_t, args|
    dir = args.dir
    Importers::Doc::Sentence.new(dir).perform
  end

  desc 'Import aliases'
  task :aliases, [:dir] => [:environment] do |_t, args|
    dir = args.dir

    Importers::Doc::Alias.new(dir).perform
  end

  desc 'Import statutes'
  task :statutes, [:dir] => [:environment] do |_t, args|
    dir = args.dir
    Importers::Doc::OffenseCode.new(dir).perform
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
