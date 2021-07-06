class CreateCaseStats < ActiveRecord::Migration[6.0]
  def change
    create_view :case_stats
  end
end
