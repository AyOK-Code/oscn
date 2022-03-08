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
  task statuses: [:environment] do
    ['2019-04', '2019-07', '2019-10', '2020-01', '2020-04', '2020-07', '2020-10', '2021-01', '2021-04', '2021-10', '2022-01'].each do |dir|
      Importers::Doc::Status.new(dir).perform
    end
  end

  desc 'Link to OSCN'
  task link_cases: [:environment] do
    Importers::Doc::LinkCases.new.perform
  end
end
