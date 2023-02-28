class CreateIssueParties < ActiveRecord::Migration[6.0]
  def change
    create_table :issue_parties do |t|
      t.references :issue, null: false, foreign_key: true
      t.references :party, null: false, foreign_key: true
      t.date :disposition_on
      t.references :verdict, null: false, foreign_key: true
      t.string :verdict_details

      t.timestamps
    end
  end
end
