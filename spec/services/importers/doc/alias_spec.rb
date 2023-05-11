require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::Alias do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { ::Doc::Alias }
    let(:file) do
      ' 0000122482BENTON                        RICHARD                       LOUIS                         JR'
    end
    let!(:profile) { create(:doc_profile, doc_number: '0000122482') }
    let(:expected_attributes) do
      {
        doc_profile_id: profile.id,
        doc_number: '0000122482'.to_i,
        last_name: 'BENTON',
        first_name: 'RICHARD',
        middle_name: 'LOUIS',
        suffix: 'JR'
      }
    end
  end
end
