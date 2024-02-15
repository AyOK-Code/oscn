namespace :ok_real_estate do
  desc 'Loop through API to pull in data'
  task agents: [:environment] do
    Importers::OkRealEstate::Import.new.import_agents
  end

  desc 'Pull Agent details'
  task agent_details: [:environment] do
    Importers::OkRealEstate::Import.new.import_agent_details
  end
end
