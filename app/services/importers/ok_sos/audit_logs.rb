module Importers
  module OkSos
    class AuditLogs < BaseImporter
      def attributes(data)
        {
          reference_number: data["reference_number"],
          audit_date: data["audit_date"],
          table_id: data["table_id"],
          field_id: data["field_id"],
          previous_value: data["previous_value"],
          current_value: data["current_value"],
          action: data["action"],
          audit_comment: data["audit_comment"]
        }
      end
    end
  end
end