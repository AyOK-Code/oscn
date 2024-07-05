require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::OffenseCode do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { Doc::OffenseCode }
    let(:sample_file) do
      '21-1021.5                     Solicit Minor For Indecent Expose/Photos                    N'
    end
    let(:expected_attributes) do
      {
        statute_code: '21-1021.5',
        description: 'Solicit Minor For Indecent Expose/Photos',
        is_violent: false
      }
    end
    let(:invalid_spacing_file) do
      '21-1021.5                Solicit Minor For Indecent Expose/Photos       N'
    end
  end
end
