require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'


RSpec.describe Importers::OkSos::AuditLogs do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/audit_logs.csv') }
    let(:record) {OkSos::AuditLog.find_by(reference_number: "3512010000")}
    let(:expected_attributes) {
      {
        reference_number: "3512010000",
        audit_date: DateTime.parse("2003-06-16 00:00:00.000000000 -0500"),
        table_id: 33,
        field_id: 211,
        previous_value: " ",
        current_value: "3512010000 - DOMESTIC LIMITED LIABILITY COMPANY - ARTICLES OF ORGANIZATION - 06/16/2003",
        action: "ADD",
        audit_comment: " "
      }
    }
  end
end
