require 'open-uri'

namespace :doc do
  desc 'Reset database and run all tasks'
  task reset: [:environment] do
    Doc::OffenseCode.delete_all
    Doc::Profile.delete_all
    Doc::Sentence.delete_all
    Doc::Alias.delete_all

    Importers::Doc::OffenseCode.new.perform
    Importers::Doc::Profile.new.perform
    Importers::Doc::Sentence.new.perform
    Importers::Doc::Alias.new.perform
  end

  desc 'Import profiles'
  task profiles: [:environment] do
    Importers::Doc::Profile.new.perform
  end

  desc 'Import sentences'
  task sentences: [:environment] do
    Importers::Doc::Sentence.new.perform
  end

  desc 'Import aliases'
  task aliases: [:environment] do
    Importers::Doc::Alias.new.perform
  end

  desc 'Import statutes'
  task statutes: [:environment] do
    Importers::Doc::Statute.new.perform
  end
end
