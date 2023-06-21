class CreateReportOcsoOscnJoins < ActiveRecord::Migration[6.0]
  def change
    create_view :report_ocso_oscn_joins
  end
end
