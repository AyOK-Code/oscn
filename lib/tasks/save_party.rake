namespace :save do
  desc 'Save party information'
  task :parties do
    Importers::Parties.perform
  end
end
