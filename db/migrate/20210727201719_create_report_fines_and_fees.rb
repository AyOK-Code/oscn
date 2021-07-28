class CreateReportFinesAndFees < ActiveRecord::Migration[6.1]
  def change
    create_view :report_fines_and_fees
  end
end
