require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::Alias do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { Doc::Alias }
    let(:sample_file) do
      '0000022574HOGNER                        CLARENCE                                                        '
    end
    let!(:profile) { create(:doc_profile, doc_number: '0000022574') }
    let(:expected_attributes) do
      {
        doc_profile_id: profile.id,
        doc_number: '0000022574'.to_i,
        last_name: 'HOGNER',
        first_name: 'CLARENCE',
        middle_name: '',
        suffix: ''
      }
    end
  end
end
