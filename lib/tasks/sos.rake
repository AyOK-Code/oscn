namespace :sos do
  desc 'Import Oklahoma Secretary of State data'
  task :import => [:environment] do
    Importers::OkSos::SplitFiles.perform('CORP_MSTR_240504.zip')
  end
end