class UpdateReportJuvenileFirearmsToVersion4 < ActiveRecord::Migration[7.0]
  def up
    drop_view :report_juvenile_firearms

    create_view :report_juvenile_firearms,
      version: 4,
      materialized: true
  end

  def down
    drop_view :report_juvenile_firearms, materialized: true

    create_view :report_juvenile_firearms,
      version: 3
  end
end
