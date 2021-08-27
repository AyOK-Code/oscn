class CreateReportFinesAndFees < ActiveRecord::Migration[6.1]
  def change
    add_index :docket_events, :payment, where: "payment != 0"
    add_index :docket_events, :adjustment, where: "adjustment != 0"
    # create_view :report_fines_and_fees, materialized: true
    # add_index :report_fines_and_fees, :court_case_id
    # add_index :report_fines_and_fees, :case_type_id
    # add_index :report_fines_and_fees, :docket_event_types_id
    # add_index :report_fines_and_fees, :event_on
  end
end
