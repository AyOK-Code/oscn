class Sentence < ActiveRecord::Migration[6.0]
  def change
    add_reference :doc_sentences, :doc_sentencing_counties, index: true
  end
end
