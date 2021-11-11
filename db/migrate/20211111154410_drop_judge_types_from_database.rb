class DropJudgeTypesFromDatabase < ActiveRecord::Migration[6.0]
  def change
    remove_column :judges, :judge_type
  end
end
