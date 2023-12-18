require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::Profile do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { ::Doc::Profile }
    let(:sample_file) { file_2023_01_format }
    let(:file_2023_01_format) do
      '0000010337SAWYER                        FRANK                         N                                 19910612INACTIVE                                          18950501MWhite                                                                                                                   501   Black                                                       INACTIVE  '
    end
    let(:file_2021_07_format) do # TODO: write legacy test for this (I don't think old date format was supported)
      ' 0000027399GARCIA                        ROSE                          L                                  11-JUL-16NORTH FORK CORRECTIONAL CENTER ESCAPE   11-SEP-43MHISPANIC                                BLACK                                   5 8 165 BROWN                                   Active   '
    end
    let(:expected_attributes) do
      {
        doc_number: '0000010337'.to_i,
        last_name: 'SAWYER',
        first_name: 'FRANK',
        middle_name: 'N',
        suffix: '',
        last_move_date: Date.parse('19910612'),
        facility: 'INACTIVE',
        birth_date: Date.parse('18950501'),
        sex: 'male',
        race: 'White',
        hair: '',
        height_ft: '5',
        height_in: '01',
        weight: '',
        eye: 'Black',
        status: 'inactive'
      }
    end
  end
end
