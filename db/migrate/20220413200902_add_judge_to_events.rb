class AddJudgeToEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference :events, :judge
  end
end
