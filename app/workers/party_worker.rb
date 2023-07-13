# Worker that scrapes the Party page on OSCN
# Ex: https://www.oscn.net/dockets/GetPartyRecord.aspx?db=oklahoma&id=5515773
class PartyWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5
  sidekiq_throttle_as :oscn

  def perform(oscn_id)
    ::Importers::PartyHtml.perform(oscn_id)
    ::Importers::PartyData.perform(oscn_id)
    party = ::Party.find_by!(oscn_id:)
    party.update(enqueued: false)
  end
end
