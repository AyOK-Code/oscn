class AddCountCodesToCounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :counts, :filed_statute_code, foreign_key: { to_table: 'count_codes' }
    add_reference :counts, :disposed_statute_code, foreign_key: { to_table: 'count_codes' }
  end
end
