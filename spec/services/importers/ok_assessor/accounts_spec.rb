require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkAssessor::Accounts do
  it_behaves_like 'ok_assessor_importer' do
    let(:sample_file) { File.read('spec/fixtures/View_OKPublicRecordAccount.csv')  }
    let(:record) { OkAssessor::Account.find_by(account_num: 'R209117010') }
    let(:expected_attributes) do
      {
        filing_number: 3_513_036_711,
        external_address_id: 4_047_286,
        business_name: '',
        agent_last_name: 'MCGHEE',
        agent_first_name: 'WILLIAM',
        agent_middle_name: '',
        agent_suffix_id: '0',
        creation_date: DateTime.parse('2021-12-09'),
        inactive_date: nil,
        normalized_name: '',
        sos_ra_flag: 0,
        entity_address_id: address.id,
        suffix_id: nil,
        entity_id: entity.id
      }
    end
  end
end
