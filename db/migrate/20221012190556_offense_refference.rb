class OffenseRefference < ActiveRecord::Migration[6.0]
  def change
    
    add_reference :tulsa_blotter_offenses,:arrests, foreign_key: { to_table: :tulsa_blotter_arrests }, index: true

  end
end
