require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::Alias do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { ::Doc::Alias }
    let(:sample_file) do
      ' 0000123482BELTON                        RICHARD                       LEWIS                         JR'
    end
    let!(:profile) { create(:doc_profile, doc_number: '0000123482') }
    let(:expected_attributes) do
      {
        doc_profile_id: profile.id,
        doc_number: '0000123482'.to_i,
        last_name: 'BELTON',
        first_name: 'RICHARD',
        middle_name: 'LEWIS',
        suffix: 'JR'
      }
    end
  end
end
