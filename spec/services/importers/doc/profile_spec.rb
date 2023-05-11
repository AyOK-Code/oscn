require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::Profile do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { ::Doc::Profile }
    let(:sample_file) { file_2023_01_format }
    let(:file_2023_01_format) do
      ' 0000027399GARCIA                        JOSE                          L                                  20160711NORTH FORK CORRECTIONAL CENTER ESCAPE   19430911MHISPANIC                                BLACK                                   5 8 165 BROWN                                   Active   '
    end
    let(:file_2021_07_format) do # TODO: write legacy test for this (I don't think old date format was supported)
      ' 0000027399GARCIA                        JOSE                          L                                  11-JUL-16NORTH FORK CORRECTIONAL CENTER ESCAPE   11-SEP-43MHISPANIC                                BLACK                                   5 8 165 BROWN                                   Active   '
    end
    let(:expected_attributes) do
      {
        doc_number: 27_399,
        last_name: 'GARCIA',
        first_name: 'JOSE',
        middle_name: 'L',
        suffix: '',
        last_move_date: Date.parse('Mon, 11 Jul 2016'),
        facility: 'NORTH FORK CORRECTIONAL CENTER ESCAPE',
        birth_date: Date.parse('Sat, 11 Sep 1943'),
        sex: 'male',
        race: 'HISPANIC',
        hair: 'BLACK',
        height_ft: '5',
        height_in: '8',
        weight: '165',
        eye: 'BROWN',
        status: 'active'
      }
    end
  end
end
