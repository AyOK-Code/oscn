class AddOscnCourtCaseToSentence < ActiveRecord::Migration[6.0]
  def change
    add_reference :doc_sentences, :court_case, foreign_key: true
  end
end
