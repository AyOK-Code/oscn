require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::Status do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { ::Doc::Status }
    let(:sample_file) do
      '0000010337SAWYER                        FRANK                         N                                 19910612INACTIVE                                          18950501MWhite                                                                                                                   501   Black                                                       INACTIVE  '
    end
    let!(:profile) { create(:doc_profile, doc_number: '0000010337') }
    let(:expected_attributes) do
      {
        doc_profile_id: profile.id,
        date: Date.parse('2023-01-01'), # uses date called in command (see shared_specs)
        facility: 'INACTIVE'
      }
    end
  end
end
