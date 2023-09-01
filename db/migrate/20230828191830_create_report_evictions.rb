class CreateReportEvictions < ActiveRecord::Migration[7.0]
  def change
    create_view :report_evictions
  end
end
