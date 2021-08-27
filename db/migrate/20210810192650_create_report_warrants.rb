class CreateReportWarrants < ActiveRecord::Migration[6.1]
  def change
    create_view :report_warrants, materialized: true
  end
end
