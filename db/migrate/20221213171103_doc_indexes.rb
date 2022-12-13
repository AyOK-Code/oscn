class DocIndexes < ActiveRecord::Migration[6.0]
  def change
    remove_index :doc_sentences, [:doc_profile_id, :sentence_id]
    remove_index :doc_statuses, [:doc_profile_id, :doc_facility_id]
    
    add_index :doc_sentences, [:doc_profile_id, :sentence_id] ,unique:true
    add_index :doc_statuses, [:doc_profile_id, :doc_facility_id], unique:true
    add_index :doc_aliases, [ :doc_profile_id, :doc_number, :last_name, :first_name, :middle_name, :suffix],unique:true, name: 'alias_index'
    add_index :doc_offense_codes, [:statute_code,:description,:is_violent],unique:true, name: 'offense_code_index'
    add_index :doc_statuses, [:doc_profile_id, :date,:facility],unique:true, name: 'status_index'
  end
end
