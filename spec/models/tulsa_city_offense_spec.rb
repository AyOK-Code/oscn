require 'rails_helper'

RSpec.describe TulsaCity::Offense, type: :model do
  describe 'associations' do
    it { should belong_to(:inmate).class_name('TulsaCity::Inmate') }
  end
  describe 'generated clean_case_number column' do
    context 'when case_number matches' do
      context 'when format ^[A-Za-z]{2}[0-9]{5,}' do
        it 'parses the case_number' do
          tulsa_city_offense = create(:tulsa_city_offense, case_number: 'CF94008641')
          tulsa_city_offense.reload
          expect(tulsa_city_offense.clean_case_number).to eq 'CF-1994-8641'
        end
      end

      context 'when format ^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}' do
        it 'parses the case_number' do
          tulsa_city_offense = create(:tulsa_city_offense, case_number: 'CF-94-8641')
          tulsa_city_offense.reload
          expect(tulsa_city_offense.clean_case_number).to eq 'CF-1994-8641'
        end
      end

      context 'when format ^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}' do
        it 'parses the case_number' do
          tulsa_city_offense = create(:tulsa_city_offense, case_number: 'CF-1994-8641')
          tulsa_city_offense.reload
          expect(tulsa_city_offense.clean_case_number).to eq 'CF-1994-8641'
        end
      end
    end
    context 'when case_number does not match' do
      it 'is null' do
        tulsa_city_offense = create(:tulsa_city_offense, case_number: 'ABC-19991-0')
        tulsa_city_offense.reload
        expect(tulsa_city_offense.clean_case_number).to be nil
      end
    end
  end
end
