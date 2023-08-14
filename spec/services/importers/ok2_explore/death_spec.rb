require 'rails_helper'

RSpec.describe Importers::Ok2Explore::Death do
  describe '.perform' do
    context 'when record is valid' do
      it 'saves the record' do
        create(:county, name: 'Oklahoma')
        record = {
          firstName: 'Bob',
          lastName: 'Loblaw',
          middleName: 'Lob',
          deathDate: '1990-02-02T00:00:00',
          deathCounty: 'Oklahoma',
          gender: 'M'
        }.with_indifferent_access

        described_class.perform(record)

        expect(Ok2Explore::Death.count).to eq(1)
        expect(Ok2Explore::Death.first.first_name).to eq('Bob')
      end
    end

    context 'when county is RogerMills' do
      it 'grabs the correct county_id' do
        create(:county, name: 'Roger Mills')
        record = {
          firstName: 'Bob',
          lastName: 'Loblaw',
          middleName: 'Lob',
          deathDate: '1990-02-02T00:00:00',
          deathCounty: 'RogerMills',
          gender: 'M'
        }.with_indifferent_access

        described_class.perform(record)

        expect(Ok2Explore::Death.count).to eq(1)
        expect(Ok2Explore::Death.first.county.name).to eq('Roger Mills')
      end
    end
  end
end
