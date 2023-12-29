require 'rails_helper'

RSpec.describe Importers::OkElection::VotingMethods do
  before do
    # TODO: Create fixture file
    let(:sample_file) { CSV.parse('path/to/file', headers: true) }
    allow(Bucket.new).to receive(:get_object).and_return(sample_file)
  end

  describe 'perform' do
    it 'imports the voting methods data' do
      skip
    end
  end
end
