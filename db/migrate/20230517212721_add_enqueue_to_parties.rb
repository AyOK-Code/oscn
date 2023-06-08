class AddEnqueueToParties < ActiveRecord::Migration[6.0]
  def change
    add_column :parties, :enqueued, :boolean, default: false
  end
end
