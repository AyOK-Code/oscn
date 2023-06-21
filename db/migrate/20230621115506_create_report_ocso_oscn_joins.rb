class CreateReportOcsoOscnJoins < ActiveRecord::Migration[6.0]
  def change
    ActiveRecord::Base.connection.execute('CREATE EXTENSION fuzzystrmatch SCHEMA public;')
    create_view :report_ocso_oscn_joins
  end
end
