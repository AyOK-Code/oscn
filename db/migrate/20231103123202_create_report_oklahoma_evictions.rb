class CreateReportOklahomaEvictions < ActiveRecord::Migration[7.0]
  def change
    create_view :report_oklahoma_evictions
  end
end
