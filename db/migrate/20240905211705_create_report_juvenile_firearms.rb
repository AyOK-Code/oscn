class CreateReportJuvenileFirearms < ActiveRecord::Migration[7.0]
  def change
    create_view :report_juvenile_firearms
  end
end
