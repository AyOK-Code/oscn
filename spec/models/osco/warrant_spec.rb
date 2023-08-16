require 'rails_helper'

RSpec.describe Ocso::Warrant do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:case_number) }
  end

  describe 'generated clean_case_number column' do
    context 'when case_number matches' do
      context 'when format ^[A-Za-z]{2}[0-9]{5,}' do
        it 'parses the case_number' do
          warrant = create('Ocso::Warrant', case_number: 'CF94008641')
          warrant.reload
          expect(warrant.clean_case_number).to eq 'CF-1994-8641'
        end
      end

      context 'when format ^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}' do
        it 'parses the case_number' do
          warrant = create('Ocso::Warrant', case_number: 'CF-94-8641')
          warrant.reload
          expect(warrant.clean_case_number).to eq 'CF-1994-8641'
        end
      end

      context 'when format ^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}' do
        it 'parses the case_number' do
          warrant = create('Ocso::Warrant', case_number: 'CF-1994-8641')
          warrant.reload
          expect(warrant.clean_case_number).to eq 'CF-1994-8641'
        end
      end
    end

    context 'when case_number does not match' do
      it 'is null' do
        warrant = create('Ocso::Warrant', case_number: 'ABC-19991-0')
        warrant.reload
        expect(warrant.clean_case_number).to be_nil
      end
    end
  end
end
