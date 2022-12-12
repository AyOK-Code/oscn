class DocImporterUpsertChanges < ActiveRecord::Migration[6.0]
  def change
    #created and updated field changes
    change_column_default :doc_aliases, :created_at, from: nil, to: ->{ 'current_timestamp' }
    change_column_default :doc_aliases, :updated_at, from: nil, to: ->{ 'current_timestamp' }

    change_column_default :doc_offense_codes, :created_at, from: nil, to: ->{ 'current_timestamp' }
    change_column_default :doc_offense_codes, :updated_at, from: nil, to: ->{ 'current_timestamp' }

    change_column_default :doc_profiles, :created_at, from: nil, to: ->{ 'current_timestamp' }
    change_column_default :doc_profiles, :updated_at, from: nil, to: ->{ 'current_timestamp' }

    change_column_default :doc_sentences, :created_at, from: nil, to: ->{ 'current_timestamp' }
    change_column_default :doc_sentences, :updated_at, from: nil, to: ->{ 'current_timestamp' }

    change_column_default :doc_statuses, :created_at, from: nil, to: ->{ 'current_timestamp' }
    change_column_default :doc_statuses, :updated_at, from: nil, to: ->{ 'current_timestamp' }

    #combined indexes
    add_index :doc_sentences, [:doc_profile_id, :sentence_id]
    add_index :doc_statuses, [:doc_profile_id, :doc_facility_id]

    

  end
end
