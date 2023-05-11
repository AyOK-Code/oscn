require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::Status do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { ::Doc::Status }
    let(:sample_file) do
      ' 0000027399GARCIA                        JOSE                          L                                  20160711NORTH FORK CORRECTIONAL CENTER ESCAPE   19430911MHISPANIC                                BLACK                                   5 8 165 BROWN                                   Active   '
    end
    let!(:profile) { create(:doc_profile, doc_number: '0000027399') }
    let(:expected_attributes) do
      {
        doc_profile_id: profile.id,
        date: Date.parse('2023-01-01'), # uses date called in command (see shared_specs)
        facility: 'NORTH FORK CORRECTIONAL CENTER ESCAPE'
      }
    end
  end
end
