require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::OffenseCode do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { ::Doc::OffenseCode }
    let(:file) do
      '10-1144                               ACTS CAUSING JUVENILE DELINQUENCY       N'
    end
    let(:invalid_spacing_file) do
      '10-1144                ACTS CAUSING JUVENILE DELINQUENCY       N'
    end
  end
end
