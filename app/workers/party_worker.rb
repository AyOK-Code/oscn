class PartyWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5
  sidekiq_throttle_as :oscn

  def perform(oscn_id)
    ::Importers::PartyData.perform(oscn_id)
  end
end
