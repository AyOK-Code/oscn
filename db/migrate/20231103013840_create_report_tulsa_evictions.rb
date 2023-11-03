class CreateReportTulsaEvictions < ActiveRecord::Migration[7.0]
  def change
    create_view :report_tulsa_evictions
  end
end
