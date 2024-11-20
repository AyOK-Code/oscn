class UpdateReportOcsoOscnJoinsToVersion3 < ActiveRecord::Migration[7.0]
  def change
    update_view :report_ocso_oscn_joins,
      version: 3,
      revert_to_version: 2
  end
end
