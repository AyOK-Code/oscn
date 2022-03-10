class AddNewFieldsToSentence < ActiveRecord::Migration[6.0]
  def change
    add_column :doc_sentences, :sentence_id, :string, null: false
    add_column :doc_sentences, :consecutive_to_sentence_id, :string
  end
end
