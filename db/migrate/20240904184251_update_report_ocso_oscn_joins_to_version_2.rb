class UpdateReportOcsoOscnJoinsToVersion2 < ActiveRecord::Migration[7.0]
  def change
    update_view :report_ocso_oscn_joins,
      version: 2,
      revert_to_version: 1
  end
end